import 'package:test/test.dart';
import 'package:promptwright/clients/gemini_client.dart' as ai;
// import 'package:genkit_google_genai/genkit_google_genai.dart';
import 'package:genkit_openai/genkit_openai.dart';

void main() {
  test('Playwright Demo Todo MVC', () async {
    final gemini = ai.GeminiClient();
    gemini.init();

    final prompt = '''
You have the following skills available to you:
1. lib/skills/promptwright.md
2. lib/skills/playwright-cli.md

Please run the test case in the following markdown file using the above skills and any necessary bash commands.
The markdown file is located at: specs/todo.md
''';

    print('\x1b[94m[PROMPT]\x1b[0m: $prompt');

    final response = await gemini.ai.generate(
      model: openAI.model('gpt-5-mini'),
      prompt: prompt,
      tools: [gemini.bash],
      maxTurns: 50,
    );

    print('\x1b[96m[RESULT]\x1b[0m: ${response.text}');

    expect(response.text, contains('PASSED'));
  }, timeout: Timeout(Duration(minutes: 5)));
}
