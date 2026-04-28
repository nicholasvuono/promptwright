import 'package:test/test.dart';
import 'package:promptwright/clients/gemini_client.dart' as ai;
// import 'package:genkit_google_genai/genkit_google_genai.dart';
import 'package:genkit_openai/genkit_openai.dart';
import 'package:promptwright/providers/skills_provider.dart';
import 'package:promptwright/schemas/schemas.dart' as schemas;

void main() {
  test('Playwright Demo Todo MVC', () async {
    final gemini = ai.GeminiClient();
    gemini.init();

    final skills = loadSkills();

    final testCase = 'specs/todo.md';

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
Run the following test: $testCase
</task>
''';

    print('\x1b[94m[TEST]\x1b[0m: $testCase');

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

    expect(response.text, contains('PASSED'));
  }, timeout: Timeout(Duration(minutes: 5)));

  test('Playwright Demo Todo Complex MVC', () async {
    final gemini = ai.GeminiClient();
    gemini.init();

    final skills = loadSkills();

    final testCase = 'specs/todo-complex.md';

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
Run the following test: $testCase
</task>
''';

    print('\x1b[94m[TEST]\x1b[0m: $testCase');

    final response = await gemini.ai.generate(
      model: openAI.model('gpt-5-mini'),
      prompt: prompt,
      tools: [gemini.playwrightCli, gemini.readFile, gemini.updateFileTool],
      outputSchema: schemas.TestResult.$schema,
      maxTurns: 50,
    );

    print('''\x1b[96m[RESULT]\x1b[0m:
${response.output?.finalResult}
Commands executed:
${response.output?.commandList.join('\n')}
''');

    expect(response.text, contains('PASSED'));
  }, timeout: Timeout(Duration(minutes: 5)));
}
