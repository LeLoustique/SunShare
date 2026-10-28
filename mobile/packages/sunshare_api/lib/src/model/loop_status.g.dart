// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LoopStatus _$open = const LoopStatus._('open');
const LoopStatus _$closed = const LoopStatus._('closed');

LoopStatus _$valueOf(String name) {
  switch (name) {
    case 'open':
      return _$open;
    case 'closed':
      return _$closed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LoopStatus> _$values = BuiltSet<LoopStatus>(const <LoopStatus>[
  _$open,
  _$closed,
]);

class _$LoopStatusMeta {
  const _$LoopStatusMeta();
  LoopStatus get open => _$open;
  LoopStatus get closed => _$closed;
  LoopStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<LoopStatus> get values => _$values;
}

abstract class _$LoopStatusMixin {
  // ignore: non_constant_identifier_names
  _$LoopStatusMeta get LoopStatus => const _$LoopStatusMeta();
}

Serializer<LoopStatus> _$loopStatusSerializer = _$LoopStatusSerializer();

class _$LoopStatusSerializer implements PrimitiveSerializer<LoopStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'open': 'open',
    'closed': 'closed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'open': 'open',
    'closed': 'closed',
  };

  @override
  final Iterable<Type> types = const <Type>[LoopStatus];
  @override
  final String wireName = 'LoopStatus';

  @override
  Object serialize(Serializers serializers, LoopStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LoopStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LoopStatus.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
