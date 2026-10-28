// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StatementStatus _$draft = const StatementStatus._('draft');
const StatementStatus _$issued = const StatementStatus._('issued');

StatementStatus _$valueOf(String name) {
  switch (name) {
    case 'draft':
      return _$draft;
    case 'issued':
      return _$issued;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StatementStatus> _$values = BuiltSet<StatementStatus>(const <StatementStatus>[
  _$draft,
  _$issued,
]);

class _$StatementStatusMeta {
  const _$StatementStatusMeta();
  StatementStatus get draft => _$draft;
  StatementStatus get issued => _$issued;
  StatementStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<StatementStatus> get values => _$values;
}

abstract class _$StatementStatusMixin {
  // ignore: non_constant_identifier_names
  _$StatementStatusMeta get StatementStatus => const _$StatementStatusMeta();
}

Serializer<StatementStatus> _$statementStatusSerializer = _$StatementStatusSerializer();

class _$StatementStatusSerializer implements PrimitiveSerializer<StatementStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'issued': 'issued',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'issued': 'issued',
  };

  @override
  final Iterable<Type> types = const <Type>[StatementStatus];
  @override
  final String wireName = 'StatementStatus';

  @override
  Object serialize(Serializers serializers, StatementStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StatementStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StatementStatus.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
