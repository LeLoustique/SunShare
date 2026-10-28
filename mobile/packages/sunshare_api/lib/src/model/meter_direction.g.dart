// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_direction.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MeterDirection _$consumption = const MeterDirection._('consumption');
const MeterDirection _$production = const MeterDirection._('production');

MeterDirection _$valueOf(String name) {
  switch (name) {
    case 'consumption':
      return _$consumption;
    case 'production':
      return _$production;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MeterDirection> _$values = BuiltSet<MeterDirection>(const <MeterDirection>[
  _$consumption,
  _$production,
]);

class _$MeterDirectionMeta {
  const _$MeterDirectionMeta();
  MeterDirection get consumption => _$consumption;
  MeterDirection get production => _$production;
  MeterDirection valueOf(String name) => _$valueOf(name);
  BuiltSet<MeterDirection> get values => _$values;
}

abstract class _$MeterDirectionMixin {
  // ignore: non_constant_identifier_names
  _$MeterDirectionMeta get MeterDirection => const _$MeterDirectionMeta();
}

Serializer<MeterDirection> _$meterDirectionSerializer = _$MeterDirectionSerializer();

class _$MeterDirectionSerializer implements PrimitiveSerializer<MeterDirection> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'consumption': 'consumption',
    'production': 'production',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'consumption': 'consumption',
    'production': 'production',
  };

  @override
  final Iterable<Type> types = const <Type>[MeterDirection];
  @override
  final String wireName = 'MeterDirection';

  @override
  Object serialize(Serializers serializers, MeterDirection object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MeterDirection deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MeterDirection.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
