// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas.dart';

// **************************************************************************
// SchemaGenerator
// **************************************************************************

base class ReadFileInput {
  factory ReadFileInput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  ReadFileInput._(this._json);

  ReadFileInput({required String filePath}) {
    _json = {'filePath': filePath};
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<ReadFileInput> $schema =
      _ReadFileInputTypeFactory();

  String get filePath {
    return _json['filePath'] as String;
  }

  set filePath(String value) {
    _json['filePath'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _ReadFileInputTypeFactory extends SchemanticType<ReadFileInput> {
  const _ReadFileInputTypeFactory();

  @override
  ReadFileInput parse(Object? json) {
    return ReadFileInput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'ReadFileInput',
    definition: $Schema
        .object(
          properties: {'filePath': $Schema.string()},
          required: ['filePath'],
        )
        .value,
    dependencies: [],
  );
}

base class FileUpdateInput {
  factory FileUpdateInput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  FileUpdateInput._(this._json);

  FileUpdateInput({required String path, required String content}) {
    _json = {'path': path, 'content': content};
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<FileUpdateInput> $schema =
      _FileUpdateInputTypeFactory();

  String get path {
    return _json['path'] as String;
  }

  set path(String value) {
    _json['path'] = value;
  }

  String get content {
    return _json['content'] as String;
  }

  set content(String value) {
    _json['content'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _FileUpdateInputTypeFactory extends SchemanticType<FileUpdateInput> {
  const _FileUpdateInputTypeFactory();

  @override
  FileUpdateInput parse(Object? json) {
    return FileUpdateInput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'FileUpdateInput',
    definition: $Schema
        .object(
          properties: {
            'path': $Schema.string(
              description:
                  'The relative path of the file to update within the allowed directory.',
            ),
            'content': $Schema.string(
              description: 'The new content to write to the file.',
            ),
          },
          required: ['path', 'content'],
        )
        .value,
    dependencies: [],
  );
}

base class PlaywrightCliInput {
  factory PlaywrightCliInput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  PlaywrightCliInput._(this._json);

  PlaywrightCliInput({required String command}) {
    _json = {'command': command};
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<PlaywrightCliInput> $schema =
      _PlaywrightCliInputTypeFactory();

  String get command {
    return _json['command'] as String;
  }

  set command(String value) {
    _json['command'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _PlaywrightCliInputTypeFactory
    extends SchemanticType<PlaywrightCliInput> {
  const _PlaywrightCliInputTypeFactory();

  @override
  PlaywrightCliInput parse(Object? json) {
    return PlaywrightCliInput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'PlaywrightCliInput',
    definition: $Schema
        .object(
          properties: {'command': $Schema.string()},
          required: ['command'],
        )
        .value,
    dependencies: [],
  );
}

base class TestResult {
  factory TestResult.fromJson(Map<String, dynamic> json) => $schema.parse(json);

  TestResult._(this._json);

  TestResult({required String finalResult, required List<String> commandList}) {
    _json = {'finalResult': finalResult, 'commandList': commandList};
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<TestResult> $schema = _TestResultTypeFactory();

  String get finalResult {
    return _json['finalResult'] as String;
  }

  set finalResult(String value) {
    _json['finalResult'] = value;
  }

  List<String> get commandList {
    return (_json['commandList'] as List).cast<String>();
  }

  set commandList(List<String> value) {
    _json['commandList'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _TestResultTypeFactory extends SchemanticType<TestResult> {
  const _TestResultTypeFactory();

  @override
  TestResult parse(Object? json) {
    return TestResult._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'TestResult',
    definition: $Schema
        .object(
          properties: {
            'finalResult': $Schema.string(
              description:
                  'Whether the test passed or failed. Structured like TEST RESULT: PASSED or TEST RESULT: FAILED',
            ),
            'commandList': $Schema.list(
              description:
                  'A list of only playwright-cli commands that were executed during the test. Prepend with ✅ if the command succeeded or ❌ if it failed.',
              items: $Schema.string(),
            ),
          },
          required: ['finalResult', 'commandList'],
        )
        .value,
    dependencies: [],
  );
}
