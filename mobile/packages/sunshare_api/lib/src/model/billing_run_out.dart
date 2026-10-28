//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sunshare_api/src/model/loop_billing_out.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'billing_run_out.g.dart';

/// BillingRunOut
///
/// Properties:
/// * [period]
/// * [loops]
/// * [skipped]
@BuiltValue()
abstract class BillingRunOut implements Built<BillingRunOut, BillingRunOutBuilder> {
  @BuiltValueField(wireName: r'period')
  String get period;

  @BuiltValueField(wireName: r'loops')
  BuiltList<LoopBillingOut> get loops;

  @BuiltValueField(wireName: r'skipped')
  BuiltList<String> get skipped;

  BillingRunOut._();

  factory BillingRunOut([void updates(BillingRunOutBuilder b)]) = _$BillingRunOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BillingRunOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BillingRunOut> get serializer => _$BillingRunOutSerializer();
}

class _$BillingRunOutSerializer implements PrimitiveSerializer<BillingRunOut> {
  @override
  final Iterable<Type> types = const [BillingRunOut, _$BillingRunOut];

  @override
  final String wireName = r'BillingRunOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BillingRunOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(String),
    );
    yield r'loops';
    yield serializers.serialize(
      object.loops,
      specifiedType: const FullType(BuiltList, [FullType(LoopBillingOut)]),
    );
    yield r'skipped';
    yield serializers.serialize(
      object.skipped,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BillingRunOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BillingRunOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.period = valueDes;
          break;
        case r'loops':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(LoopBillingOut)]),
          ) as BuiltList<LoopBillingOut>;
          result.loops.replace(valueDes);
          break;
        case r'skipped':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.skipped.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BillingRunOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BillingRunOutBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
