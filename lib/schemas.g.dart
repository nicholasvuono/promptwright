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
