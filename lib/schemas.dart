import 'package:schemantic/schemantic.dart';

part 'schemas.g.dart';

@Schema()
abstract class $ReadFileInput {
  String get filePath;
}
