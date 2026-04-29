import 'dart:io';
import 'dart:async';
import 'package:args/args.dart';
import 'package:pool/pool.dart';
import 'package:promptwright/providers/skills_provider.dart';
import 'package:promptwright/clients/open_ai_client.dart' as ai;

// Simple state for our tests
enum TestStatus { pending, running, success, failed }

class TestTracker {
  final String path;
  TestStatus status = TestStatus.pending;
  TestTracker(this.path);
}

Future<void> main(List<String> arguments) async {
  try {
    final parser = ArgParser()
      ..addOption('test', abbr: 't')
      ..addOption('dir', abbr: 'd')
      ..addOption('workers', abbr: 'w', defaultsTo: '1');

    final results = parser.parse(arguments);
    final String testPath = (results['test'] as String?) ?? '';
    final String testsDir = (results['dir'] as String?) ?? '';
    final int workerCount = int.tryParse(results['workers'] ?? '1') ?? 1;

    final selectedOption =
        [
          if (results.wasParsed('dir')) 'TESTS_DIR',
          if (results.wasParsed('test')) 'TEST_PATH',
        ].firstOrNull ??
        'NONE';

    if (selectedOption == 'NONE') {
      stderr.writeln(
        '\x1b[31m[ERROR]\x1b[0m: --test or --dir must be provided!',
      );
      exit(64);
    }

    final testFiles = selectedOption == 'TEST_PATH'
        ? [testPath]
        : Directory(testsDir)
              .listSync()
              .whereType<File>()
              .where((file) => file.path.endsWith('.md'))
              .map((file) => file.path)
              .toList();

    // Initialize tracking state
    final trackers = testFiles.map((f) => TestTracker(f)).toList();

    final openai = ai.OpenAiClient();
    openai.init();
    final skills = loadSkills();
    final pool = Pool(workerCount);

    // --- LIVE UI ENGINE ---
    int frame = 0;
    const spinner = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];

    void renderUI() {
      // Move cursor up to the start of the test list to overwrite
      if (frame > 0) {
        stdout.write('\x1b[${trackers.length}A');
      }

      for (var t in trackers) {
        String icon;
        switch (t.status) {
          case TestStatus.pending:
            icon = '○';
            break;
          case TestStatus.running:
            icon = '\x1b[94m${spinner[frame % spinner.length]}\x1b[0m';
            break;
          case TestStatus.success:
            icon = '\x1b[32m✔\x1b[0m';
            break;
          case TestStatus.failed:
            icon = '\x1b[31m✘\x1b[0m';
            break;
        }
        // Clear line and print status
        stdout.write('\x1b[2K\r$icon ${t.path}\n');
      }
      frame++;
    }

    // Start the "Heartbeat" for the spinner
    final uiTimer = Timer.periodic(
      Duration(milliseconds: 80),
      (_) => renderUI(),
    );

    final testTasks = trackers.map((tracker) {
      return pool.withResource(() async {
        tracker.status = TestStatus.running;

        try {
          final prompt =
              '''
<system_instruction>
You are an Test Runner. Run the markdown test case provided in the <task>.
</system_instruction>
<knowledge_base>
${skills.promptwrightSkill}
${skills.playwrightCliSkill}
</knowledge_base>
<task>
Run the following test: ${tracker.path}
</task>
''';

          final response = await openai.generator(prompt);

          // Logic for pass/fail (adjust based on your actual response object)
          if (response.output?.finalResult != null) {
            tracker.status = TestStatus.success;
          } else {
            tracker.status = TestStatus.failed;
          }
        } catch (e) {
          tracker.status = TestStatus.failed;
        }
      });
    });

    await Future.wait(testTasks);

    uiTimer.cancel();
    renderUI(); // Final render
    await pool.close();

    print('\n🏁 All tests finished.');
  } catch (e) {
    stderr.writeln('Error: $e');
    exit(64);
  }
}
