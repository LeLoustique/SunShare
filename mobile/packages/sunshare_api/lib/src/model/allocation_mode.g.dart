// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_mode.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AllocationMode _$static_ = const AllocationMode._('static_');
const AllocationMode _$dynamicDefault = const AllocationMode._('dynamicDefault');
const AllocationMode _$dynamicCustom = const AllocationMode._('dynamicCustom');

AllocationMode _$valueOf(String name) {
  switch (name) {
    case 'static_':
      return _$static_;
    case 'dynamicDefault':
      return _$dynamicDefault;
    case 'dynamicCustom':
      return _$dynamicCustom;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AllocationMode> _$values = BuiltSet<AllocationMode>(const <AllocationMode>[
  _$static_,
  _$dynamicDefault,
  _$dynamicCustom,
]);

class _$AllocationModeMeta {
  const _$AllocationModeMeta();
  AllocationMode get static_ => _$static_;
  AllocationMode get dynamicDefault => _$dynamicDefault;
  AllocationMode get dynamicCustom => _$dynamicCustom;
  AllocationMode valueOf(String name) => _$valueOf(name);
  BuiltSet<AllocationMode> get values => _$values;
}

abstract class _$AllocationModeMixin {
  // ignore: non_constant_identifier_names
  _$AllocationModeMeta get AllocationMode => const _$AllocationModeMeta();
}

Serializer<AllocationMode> _$allocationModeSerializer = _$AllocationModeSerializer();

class _$AllocationModeSerializer implements PrimitiveSerializer<AllocationMode> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'static_': 'static',
    'dynamicDefault': 'dynamic_default',
    'dynamicCustom': 'dynamic_custom',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'static': 'static_',
    'dynamic_default': 'dynamicDefault',
    'dynamic_custom': 'dynamicCustom',
  };

  @override
  final Iterable<Type> types = const <Type>[AllocationMode];
  @override
  final String wireName = 'AllocationMode';

  @override
  Object serialize(Serializers serializers, AllocationMode object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AllocationMode deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AllocationMode.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
