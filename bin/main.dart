import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'dart:collection';

import 'package:args/args.dart';
import 'package:mason_logger/mason_logger.dart' hide Progress;
import 'package:promptwright/providers/skills_provider.dart';
import 'package:promptwright/clients/open_ai_client.dart' as ai;

enum TestStatus { pending, running, success, failed }

class TestState {
  final String path;
  TestStatus status = TestStatus.pending;
  String action = 'Waiting...';
  TestState(this.path);
}

/// --- WORKER ISOLATE ENTRY POINT ---
void workerEntry(Map<String, dynamic> message) async {
  final sendPort = message['sendPort'] as SendPort;
  final path = message['path'] as String;
  final skills = message['skills'];

  final workerAi = ai.OpenAiClient();
  workerAi.init();

  try {
    sendPort.send({'type': 'status', 'path': path});

    final prompt =
        '''
<system_instruction>
You are an Test Runner. Using the skills in the <knowledge_base> below and the already installed playwright-cli tool. Run the markdown test case provided in the <task>. Follow the `promptwrightSkill` caching rules: use existing `## Cached` commands first when present, and call `updateFile` only if the cache is missing, a command had to be healed, or the successful commands were wildly different from the existing cached commands.
</system_instruction>

<knowledge_base>
${skills.promptwrightSkill}
${skills.playwrightCliSkill}
</knowledge_base>

<task>
Run the following test: $path
</task>
''';

    await workerAi.generator(
      prompt,
      onAction: (tool, detail) {
        sendPort.send({
          'type': 'action',
          'path': path,
          'action':
              '$tool: ${detail.length > 50 ? "${detail.substring(0, 49)}..." : detail}',
        });
      },
    );

    sendPort.send({'type': 'done', 'status': 'success', 'path': path});
  } catch (e) {
    sendPort.send({
      'type': 'done',
      'status': 'failed',
      'path': path,
      'error': e.toString().split('\n').first,
    });
  }
}

Future<void> main(List<String> arguments) async {
  final logger = Logger();
  final parser = ArgParser()
    ..addOption('test', abbr: 't')
    ..addOption('dir', abbr: 'd')
    ..addOption('workers', abbr: 'w', defaultsTo: '1');

  final results = parser.parse(arguments);
  final String testPath = (results['test'] as String?) ?? '';
  final String testsDir = (results['dir'] as String?) ?? '';
  final int workerCount = int.tryParse(results['workers'] ?? '1') ?? 1;

  final testFiles = results.wasParsed('test')
      ? [testPath]
      : Directory(testsDir)
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.md'))
            .map((f) => f.path)
            .toList();

  if (testFiles.isEmpty) {
    logger.err('No tests found.');
    return;
  }

  final states = testFiles.map((f) => TestState(f)).toList();
  final skills = loadSkills();

  // --- UI RENDER ENGINE ---
  int frame = 0;
  final spinner = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];

  void render() {
    if (frame > 0) stdout.write('\x1b[${states.length}A');

    for (var state in states) {
      String prefix;
      switch (state.status) {
        case TestStatus.pending:
          prefix = '  ○ ';
          break;
        case TestStatus.running:
          prefix = '  \x1b[94m${spinner[frame % spinner.length]}\x1b[0m ';
          break;
        case TestStatus.success:
          prefix = '  \x1b[32m✔\x1b[0m ';
          break;
        case TestStatus.failed:
          prefix = '  \x1b[31m✘\x1b[0m ';
          break;
      }

      final dimAction = state.status == TestStatus.running
          ? '\x1b[2m — ${state.action}\x1b[0m'
          : '';

      final line = '$prefix${state.path}$dimAction';
      stdout.write('\x1b[2K\r$line\n');
    }

    frame++;
  }

  final timer = Timer.periodic(
    const Duration(milliseconds: 100),
    (_) => render(),
  );

  // --- ISOLATE MANAGEMENT ---
  final receivePort = ReceivePort();
  final doneCompleter = Completer<void>();
  final queue = Queue<TestState>.from(states);

  int active = 0;
  int completed = 0;

  void spawnNext() async {
    if (queue.isEmpty) return;
    if (active >= workerCount) return;

    final state = queue.removeFirst();
    active++;

    await Isolate.spawn(workerEntry, {
      'sendPort': receivePort.sendPort,
      'path': state.path,
      'skills': skills,
    });

    // Fill remaining capacity
    spawnNext();
  }

  receivePort.listen((message) {
    final path = message['path'];
    final state = states.firstWhere((s) => s.path == path);

    switch (message['type']) {
      case 'status':
        state.status = TestStatus.running;
        break;

      case 'action':
        state.action = message['action'];
        break;

      case 'done':
        state.status = message['status'] == 'success'
            ? TestStatus.success
            : TestStatus.failed;

        if (message['error'] != null) {
          state.action = message['error'];
        }

        active--;
        completed++;

        if (completed == states.length) {
          receivePort.close();
          doneCompleter.complete(); // ✅ FIX
        } else {
          spawnNext();
        }
        break;
    }
  });

  // Start initial workers
  for (int i = 0; i < workerCount; i++) {
    spawnNext();
  }

  await doneCompleter.future;

  timer.cancel();
  render();
  print('\n🏁 Done.');
}
