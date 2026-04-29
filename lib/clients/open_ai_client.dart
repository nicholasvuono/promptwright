import 'dart:io';
import 'package:genkit/genkit.dart';
import 'package:genkit_openai/genkit_openai.dart';
import 'package:promptwright/schemas/schemas.dart' as schemas;

class OpenAiClient {
  late Genkit ai;
  late Tool playwrightCli, readFile, updateFileTool;

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
        // print('\x1b[38;5;166m[READ FILE]\x1b[0m: ${input.filePath}');
        final contents = await File(
          input.filePath,
        ).readAsString(); // use streams later
        return contents;
      },
    );
  }

  void definePlaywrightCliTool() {
    playwrightCli = ai.defineTool(
      name: 'playwrightCli',
      description: '''
        Executes playwright-cli commands. Check playwright-cli --help for available commands.
        The tool returns stdout, stderr, and the exit code. If a command fails, use the stderr or exit code to diagnose and retry.
      ''',
      inputSchema: schemas.PlaywrightCliInput.$schema,
      fn: (input, _) async {
        try {
          // print('\x1b[38;5;166m[PLAYWRIGHT-CLI]\x1b[0m: ${input.command}');
          final result = await Process.run('bash', ['-c', input.command]);

          // Return a structured summary so the agent can react to failure
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
      description: 'Safely updates a file within the project directory.',
      inputSchema: schemas.FileUpdateInput.$schema,
      fn: (input, context) async {
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

  Future<GenerateResponseHelper> generator(String prompt) async {
    return await ai.generate(
      model: openAI.model('gpt-5-mini'),
      prompt: prompt,
      tools: [playwrightCli, readFile],
      outputSchema: schemas.TestResult.$schema,
      maxTurns: 50,
    );
  }
}
