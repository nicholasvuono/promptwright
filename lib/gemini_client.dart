import 'dart:io';

import 'package:genkit/genkit.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';

import 'package:promptwright/schemas.dart' as schemas;

class GeminiClient {
  late Genkit ai;
  late Tool readFile;

  void init() {
    ai = Genkit(plugins: [googleAI()]);
    readFile = defineReadFileTool();
  }

  Tool defineReadFileTool() {
    return ai.defineTool(
      name: 'readFile',
      description: 'Reads the contents of a give file.',
      inputSchema: schemas.ReadFileInput.$schema,
      fn: (input, _) async {
        final contents = await File(
          input.filePath,
        ).readAsString(); // use streams later
        return contents;
      },
    );
  }
}
