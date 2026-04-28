import 'package:schemantic/schemantic.dart';

part 'schemas.g.dart';

@Schema()
abstract class $BashInput {
  String get command;
  // TODO: gate system access via Process.run invocation in the future
  // String get workingDirectory;
}

@Schema()
abstract class $TestResult {
  @Field(
    description:
        'Whether the test passed or failed. Structured like TEST RESULT: PASSED or TEST RESULT: FAILED',
  )
  String get finalResult;

  @Field(
    description:
        'A list of only playwright-cli commands that were executed during the test. Prepend with ✅ if the command succeeded or ❌ if it failed.',
  )
  List<String> get commandList;
}
