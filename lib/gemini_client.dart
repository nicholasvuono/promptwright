import 'dart:io';

import 'package:genkit/genkit.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';

import 'package:promptwright/schemas.dart' as schemas;

class GeminiClient {
  late Genkit ai;
  late Tool bash;

  void init() {
    ai = Genkit(plugins: [googleAI()]);
    defineLBashTool();
  }

  void defineLBashTool() {
    bash = ai.defineTool(
      name: 'runBash',
      description: '''
        Executes an arbitrary bash command or script. This is the primary tool for 
        interacting with the operating system. Use it to:
        1. File Management: Create, move, delete, or search files (mkdir, rm, grep, find).
        2. Development: Run compilers, build scripts, or dependency managers (npm, dart, cargo).
        3. System State: Check environment variables, current directory, or network status.
        4. Orchestration: Chain multiple commands using pipes (|), redirects (>), or logical operators (&&, ||).
        The tool returns stdout, stderr, and the exit code. If a command fails, use the stderr or exit code to diagnose and retry.
      ''',
      inputSchema: schemas.BashInput.$schema,
      fn: (input, _) async {
        try {
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
}
