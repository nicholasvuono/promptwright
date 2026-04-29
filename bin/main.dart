import 'dart:io';
import 'dart:async';
import 'package:args/args.dart';
import 'package:pool/pool.dart';
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

  // Initialize UI States
  final states = testFiles.map((f) => TestState(f)).toList();
  final skills = loadSkills();
  final pool = Pool(workerCount);

  // --- THE UI RENDER ENGINE ---
  int frame = 0;
  final spinner = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];

  void render() {
    // Move cursor up by the number of tests to overwrite
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

      // Clear line and print
      stdout.write('\x1b[2K\r$line\n');
    }
    frame++;
  }

  // Start the heartbeat
  final timer = Timer.periodic(Duration(milliseconds: 100), (_) => render());

  final tasks = states.map((state) {
    return pool.withResource(() async {
      state.status = TestStatus.running;
      final workerAi = ai.OpenAiClient();
      workerAi.init();

      try {
        final prompt =
            'Run test: ${state.path} using skills: ${skills.promptwrightSkill}';

        await workerAi.generator(
          prompt,
          onAction: (tool, detail) {
            state.action =
                '$tool: ${detail.length > 50 ? "${detail.substring(0, 49)}..." : detail}';
          },
        );
        state.status = TestStatus.success;
      } catch (e) {
        state.status = TestStatus.failed;
        state.action = e.toString().split('\n').first;
      }
    });
  });

  await Future.wait(tasks);
  timer.cancel();
  render(); // Final draw
  print('\n🏁 Done.');
}
