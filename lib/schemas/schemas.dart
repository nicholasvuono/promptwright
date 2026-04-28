import 'package:schemantic/schemantic.dart';

part 'schemas.g.dart';

@Schema()
abstract class $ReadFileInput {
  String get filePath;
}

@Schema()
abstract class $FileUpdateInput {
  @Field(
    description:
        'The relative path of the file to update within the allowed directory.',
  )
  String get path;

  @Field(description: 'The new content to write to the file.')
  String get content;
}

@Schema()
abstract class $PlaywrightCliInput {
  String get command;
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
