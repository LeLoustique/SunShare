//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loop_status.g.dart';

class LoopStatus extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const LoopStatus open = _$open;
  @BuiltValueEnumConst(wireName: r'closed')
  static const LoopStatus closed = _$closed;

  static Serializer<LoopStatus> get serializer => _$loopStatusSerializer;

  const LoopStatus._(String name) : super(name);

  static BuiltSet<LoopStatus> get values => _$values;
  static LoopStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class LoopStatusMixin = Object with _$LoopStatusMixin;
