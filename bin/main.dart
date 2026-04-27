import 'package:promptwright/clients/gemini_client.dart' as ai;
import 'package:genkit_google_genai/genkit_google_genai.dart';

void main(List<String> arguments) async {
  final gemini = ai.GeminiClient();
  gemini.init();

  final prompt =
      'Read and briefly describe in one sentence what it does /Users/nick/promptwright/bin/promptwright.dart';

  print('\x1b[94m[PROMPT]\x1b[0m: $prompt');

  final response = await gemini.ai.generate(
    model: googleAI.gemini('gemini-2.5-flash'),
    prompt: prompt,
    tools: [gemini.bash],
  );

  print('\x1b[96m[RESULT]\x1b[0m: ${response.text}');
}
