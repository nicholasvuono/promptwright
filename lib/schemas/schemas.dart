import 'package:schemantic/schemantic.dart';

part 'schemas.g.dart';

@Schema()
abstract class $BashInput {
  String get command;
  // TODO: gate system access via Process.run invocation in the future
  // String get workingDirectory;
}
