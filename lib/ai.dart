import 'package:genkit/genkit.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';

Future<String> askGeminiWhyGenKitIsAwesome() async {
  final ai = Genkit(plugins: [googleAI()]);

  final response = await ai.generate(
    model: googleAI.gemini('gemini-2.5-flash'),
    prompt: 'Why is Genkit awesome?',
  );

  return response.text;
}
