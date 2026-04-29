import 'dart:io';
import 'package:args/args.dart';
import 'package:genkit_openai/genkit_openai.dart';
import 'package:promptwright/providers/skills_provider.dart';
import 'package:promptwright/clients/gemini_client.dart' as ai;
import 'package:promptwright/schemas/schemas.dart' as schemas;

Future<void> main(List<String> arguments) async {
  final parser = ArgParser();

  // Define the flags
  parser.addFlag(
    'test',
    abbr: 't',
    help: 'filepath of the test case to run',
    negatable: false,
  );

  try {
    final parser = ArgParser()
      ..addOption(
        'test',
        abbr: 't',
        help: 'Path to the markdown test case file',
        valueHelp: 'FILE_PATH', // Helpful hint in the --help output
        mandatory: true, // Automatically errors if missing!
      );

    final results = parser.parse(arguments);

    final String testPath = results['test'];

    // 1. Validate the file exists
    if (!File(testPath).existsSync()) {
      stderr.writeln('\x1b[31m[ERROR]\x1b[0m: File not found at "$testPath"');
      exit(66); // 66 = EX_NOINPUT (Standard exit code for missing input)
    }

    final gemini = ai.OpenAiClient();
    gemini.init();

    final skills = loadSkills();

    final prompt =
        '''
<system_instruction>
You are an Test Runner. Using the skills in the <knowledge_base> below and the already installed playwright-cli tool. Run the markdown test case provided int eh <task>.
</system_instruction>

<knowledge_base>
${skills.promptwrightSkill}
${skills.playwrightCliSkill}
</knowledge_base>

<task>
Run the following test: $testPath
</task>
''';

    print('\x1b[94m[TEST]\x1b[0m: $testPath');

    final response = await gemini.ai.generate(
      model: openAI.model('gpt-5-mini'),
      prompt: prompt,
      tools: [gemini.playwrightCli, gemini.readFile],
      outputSchema: schemas.TestResult.$schema,
      maxTurns: 50,
    );

    print('''\x1b[96m[RESULT]\x1b[0m:
${response.output?.finalResult}
Commands executed:
${response.output?.commandList.join('\n')}
''');
  } catch (e) {
    stderr.writeln('Error: ${e.toString()}');
    exit(64); // Command line usage error
  }
}
