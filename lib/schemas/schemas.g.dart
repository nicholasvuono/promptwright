// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas.dart';

// **************************************************************************
// SchemaGenerator
// **************************************************************************

base class BashInput {
  factory BashInput.fromJson(Map<String, dynamic> json) => $schema.parse(json);

  BashInput._(this._json);

  BashInput({required String command}) {
    _json = {'command': command};
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<BashInput> $schema = _BashInputTypeFactory();

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

base class _BashInputTypeFactory extends SchemanticType<BashInput> {
  const _BashInputTypeFactory();

  @override
  BashInput parse(Object? json) {
    return BashInput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'BashInput',
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
