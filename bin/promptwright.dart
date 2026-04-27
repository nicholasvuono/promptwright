import 'package:promptwright/gemini_client.dart' as ai;
import 'package:genkit_google_genai/genkit_google_genai.dart';

void main(List<String> arguments) async {
  final gemini = ai.GeminiClient();
  gemini.init();

  final response = await gemini.ai.generate(
    model: googleAI.gemini('gemini-2.5-flash'),
    prompt:
        'Read and describe what is in the following file the following file /Users/nick/promptwright/bin/promptwright.dart',
    tools: [gemini.bash],
  );

  print(response.text);
}
