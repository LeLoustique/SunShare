//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loop_billing_out.g.dart';

/// LoopBillingOut
///
/// Properties:
/// * [loopId]
/// * [loopName]
/// * [statements]
/// * [consumersEur]
/// * [payoutsEur]
/// * [commissionEur]
@BuiltValue()
abstract class LoopBillingOut implements Built<LoopBillingOut, LoopBillingOutBuilder> {
  @BuiltValueField(wireName: r'loop_id')
  String get loopId;

  @BuiltValueField(wireName: r'loop_name')
  String get loopName;

  @BuiltValueField(wireName: r'statements')
  int get statements;

  @BuiltValueField(wireName: r'consumers_eur')
  String get consumersEur;

  @BuiltValueField(wireName: r'payouts_eur')
  String get payoutsEur;

  @BuiltValueField(wireName: r'commission_eur')
  String get commissionEur;

  LoopBillingOut._();

  factory LoopBillingOut([void updates(LoopBillingOutBuilder b)]) = _$LoopBillingOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoopBillingOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoopBillingOut> get serializer => _$LoopBillingOutSerializer();
}

class _$LoopBillingOutSerializer implements PrimitiveSerializer<LoopBillingOut> {
  @override
  final Iterable<Type> types = const [LoopBillingOut, _$LoopBillingOut];

  @override
  final String wireName = r'LoopBillingOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoopBillingOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'loop_id';
    yield serializers.serialize(
      object.loopId,
      specifiedType: const FullType(String),
    );
    yield r'loop_name';
    yield serializers.serialize(
      object.loopName,
      specifiedType: const FullType(String),
    );
    yield r'statements';
    yield serializers.serialize(
      object.statements,
      specifiedType: const FullType(int),
    );
    yield r'consumers_eur';
    yield serializers.serialize(
      object.consumersEur,
      specifiedType: const FullType(String),
    );
    yield r'payouts_eur';
    yield serializers.serialize(
      object.payoutsEur,
      specifiedType: const FullType(String),
    );
    yield r'commission_eur';
    yield serializers.serialize(
      object.commissionEur,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoopBillingOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoopBillingOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'loop_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.loopId = valueDes;
          break;
        case r'loop_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.loopName = valueDes;
          break;
        case r'statements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.statements = valueDes;
          break;
        case r'consumers_eur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.consumersEur = valueDes;
          break;
        case r'payouts_eur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.payoutsEur = valueDes;
          break;
        case r'commission_eur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.commissionEur = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoopBillingOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoopBillingOutBuilder();
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
