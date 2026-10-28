//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_mode.g.dart';

class AllocationMode extends EnumClass {
  /// Clé de répartition transmise à Enedis (cahier des charges §8.2).
  @BuiltValueEnumConst(wireName: r'static')
  static const AllocationMode static_ = _$static_;

  /// Clé de répartition transmise à Enedis (cahier des charges §8.2).
  @BuiltValueEnumConst(wireName: r'dynamic_default')
  static const AllocationMode dynamicDefault = _$dynamicDefault;

  /// Clé de répartition transmise à Enedis (cahier des charges §8.2).
  @BuiltValueEnumConst(wireName: r'dynamic_custom')
  static const AllocationMode dynamicCustom = _$dynamicCustom;

  static Serializer<AllocationMode> get serializer => _$allocationModeSerializer;

  const AllocationMode._(String name) : super(name);

  static BuiltSet<AllocationMode> get values => _$values;
  static AllocationMode valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AllocationModeMixin = Object with _$AllocationModeMixin;
