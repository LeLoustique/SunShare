//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'statement_status.g.dart';

class StatementStatus extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const StatementStatus draft = _$draft;
  @BuiltValueEnumConst(wireName: r'issued')
  static const StatementStatus issued = _$issued;

  static Serializer<StatementStatus> get serializer => _$statementStatusSerializer;

  const StatementStatus._(String name) : super(name);

  static BuiltSet<StatementStatus> get values => _$values;
  static StatementStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class StatementStatusMixin = Object with _$StatementStatusMixin;
