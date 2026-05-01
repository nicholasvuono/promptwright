import 'dart:io';
import 'package:genkit/genkit.dart';
import 'package:genkit_openai/genkit_openai.dart';
import 'package:promptwright/schemas/schemas.dart' as schemas;

class OpenAiClient {
  late Genkit ai;
  late Tool playwrightCli, readFile, updateFileTool;

  // A callback that we can set per-test run
  void Function(String toolName, String detail)? onToolCall;

  void init() {
    ai = Genkit(
      plugins: [openAI(apiKey: Platform.environment['OPENAI_API_KEY'])],
    );
    defineReadFileTool();
    definePlaywrightCliTool();
    defineUpdateFileTool();
  }

  void defineReadFileTool() {
    readFile = ai.defineTool(
      name: 'readFile',
      description: 'Reads the contents of a give file.',
      inputSchema: schemas.ReadFileInput.$schema,
      fn: (input, _) async {
        // Notify the UI
        onToolCall?.call('readFile', input.filePath);

        final contents = await File(input.filePath).readAsString();
        return contents;
      },
    );
  }

  void definePlaywrightCliTool() {
    playwrightCli = ai.defineTool(
      name: 'playwrightCli',
      description: 'Executes playwright-cli commands...',
      inputSchema: schemas.PlaywrightCliInput.$schema,
      fn: (input, _) async {
        // Notify the UI with the specific command being run
        onToolCall?.call('playwrightCli', input.command);

        try {
          final result = await Process.run('bash', ['-c', input.command]);
          return {
            'stdout': result.stdout,
            'stderr': result.stderr,
            'exitCode': result.exitCode,
          }.toString();
        } catch (e) {
          return 'Execution failed: $e';
        }
      },
    );
  }

  void defineUpdateFileTool() {
    updateFileTool = ai.defineTool(
      name: 'updateFile',
      description:
          'Safely updates a file within the project directory. For markdown tests, use this only when the ## Cached section is missing, a cached command was healed, or the successful commands were wildly different from the existing cached commands. Write the complete updated test file content.',
      inputSchema: schemas.FileUpdateInput.$schema,
      fn: (input, context) async {
        onToolCall?.call('updateFile', input.path);
        // 1. Define the allowed root (e.g., project data directory)
        final rootDir = Directory.current.path;

        // 2. Validate path to prevent directory traversal attacks (../../)
        final targetFile = File('$rootDir/${input.path}');
        if (!targetFile.path.startsWith(rootDir)) {
          throw Exception(
            'Security Error: Access denied to path: ${input.path}',
          );
        }

        // 3. Perform the update
        // print('\x1b[38;5;166m[UPDATE FILE]\x1b[0m: ${input.path}');
        await targetFile.writeAsString(input.content);
        return 'Successfully updated ${input.path}';
      },
    );
  }

  Future<GenerateResponseHelper> generator(
    String prompt, {
    void Function(String tool, String detail)?
    onAction, // Pass-through listener
  }) async {
    onToolCall = onAction; // Set the active listener for this turn

    return await ai.generate(
      model: openAI.model('gpt-5-mini'),
      prompt: prompt,
      tools: [playwrightCli, readFile, updateFileTool],
      outputSchema: schemas.TestResult.$schema,
      maxTurns: 50,
    );
  }
}
