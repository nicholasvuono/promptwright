import 'package:promptwright/gemini_client.dart' as ai;
import 'package:genkit_google_genai/genkit_google_genai.dart';

void main(List<String> arguments) async {
  final gemini = ai.GeminiClient();
  gemini.init();

  final response = await gemini.ai.generate(
    model: googleAI.gemini('gemini-2.5-flash'),
    prompt: '/Users/nick/promptwright/bin/promptwright.dart',
    tools: [gemini.readFile],
  );

  print(response.text);
}
