//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'meter_direction.g.dart';

class MeterDirection extends EnumClass {
  @BuiltValueEnumConst(wireName: r'consumption')
  static const MeterDirection consumption = _$consumption;
  @BuiltValueEnumConst(wireName: r'production')
  static const MeterDirection production = _$production;

  static Serializer<MeterDirection> get serializer => _$meterDirectionSerializer;

  const MeterDirection._(String name) : super(name);

  static BuiltSet<MeterDirection> get values => _$values;
  static MeterDirection valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MeterDirectionMixin = Object with _$MeterDirectionMixin;
