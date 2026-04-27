import 'package:promptwright/clients/gemini_client.dart' as ai;
import 'package:genkit_google_genai/genkit_google_genai.dart';

void main(List<String> arguments) async {
  final gemini = ai.GeminiClient();
  gemini.init();

  final prompt = '''
    Act as a test runner. The lib/skills/playwright-cli.md is a skill for you to learn and use for playwright-cli related tasks.
    There is a markdown test file that contains a markdown test case. The goal is to read the test case, understand
    the steps, define the playwright cli commands needed to execute the test case, and then execute those commands. If the test run
    is successful, take a screenshot of the result. If successful, also append the playwright-cli commands to the test file under a "## Cached" section. 
    If it fails, analyze the error message and retry with a corrected command.

    If it contains a '## Cached' section, read the commands under that section and try to execute them first. If they succeed,
    you can skip straight to the screenshot step. If they fail, proceed with the normal process of defining and executing commands.
    Replace the cached commands with the new commands if the new commands succeed.

    The markdown test file is: specs/todo.md
  ''';

  print('\x1b[94m[PROMPT]\x1b[0m: $prompt');

  final response = await gemini.ai.generate(
    model: googleAI.gemini('gemini-2.5-flash'),
    prompt: prompt,
    tools: [gemini.bash],
    maxTurns: 50,
  );

  print('\x1b[96m[RESULT]\x1b[0m: ${response.text}');
}
