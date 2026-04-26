import 'package:promptwright/promptwright.dart' as promptwright;
import 'package:promptwright/ai.dart' as ai;

void main(List<String> arguments) async {
  final response = await ai.askGeminiWhyGenKitIsAwesome();
  print(promptwright.calculate());
  print(response);
}
