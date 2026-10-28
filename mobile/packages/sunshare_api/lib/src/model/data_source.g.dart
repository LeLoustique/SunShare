// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DataSource _$enedis = const DataSource._('enedis');
const DataSource _$simulated = const DataSource._('simulated');

DataSource _$valueOf(String name) {
  switch (name) {
    case 'enedis':
      return _$enedis;
    case 'simulated':
      return _$simulated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DataSource> _$values = BuiltSet<DataSource>(const <DataSource>[
  _$enedis,
  _$simulated,
]);

class _$DataSourceMeta {
  const _$DataSourceMeta();
  DataSource get enedis => _$enedis;
  DataSource get simulated => _$simulated;
  DataSource valueOf(String name) => _$valueOf(name);
  BuiltSet<DataSource> get values => _$values;
}

abstract class _$DataSourceMixin {
  // ignore: non_constant_identifier_names
  _$DataSourceMeta get DataSource => const _$DataSourceMeta();
}

Serializer<DataSource> _$dataSourceSerializer = _$DataSourceSerializer();

class _$DataSourceSerializer implements PrimitiveSerializer<DataSource> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'enedis': 'enedis',
    'simulated': 'simulated',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'enedis': 'enedis',
    'simulated': 'simulated',
  };

  @override
  final Iterable<Type> types = const <Type>[DataSource];
  @override
  final String wireName = 'DataSource';

  @override
  Object serialize(Serializers serializers, DataSource object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DataSource deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DataSource.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
