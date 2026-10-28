//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'consumer_summary.g.dart';

/// ConsumerSummary
///
/// Properties:
/// * [consumptionKwh]
/// * [localKwh]
/// * [selfConsumptionRate]
/// * [amountEur]
@BuiltValue()
abstract class ConsumerSummary implements Built<ConsumerSummary, ConsumerSummaryBuilder> {
  @BuiltValueField(wireName: r'consumption_kwh')
  num get consumptionKwh;

  @BuiltValueField(wireName: r'local_kwh')
  num get localKwh;

  @BuiltValueField(wireName: r'self_consumption_rate')
  num? get selfConsumptionRate;

  @BuiltValueField(wireName: r'amount_eur')
  String get amountEur;

  ConsumerSummary._();

  factory ConsumerSummary([void updates(ConsumerSummaryBuilder b)]) = _$ConsumerSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConsumerSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConsumerSummary> get serializer => _$ConsumerSummarySerializer();
}

class _$ConsumerSummarySerializer implements PrimitiveSerializer<ConsumerSummary> {
  @override
  final Iterable<Type> types = const [ConsumerSummary, _$ConsumerSummary];

  @override
  final String wireName = r'ConsumerSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConsumerSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'consumption_kwh';
    yield serializers.serialize(
      object.consumptionKwh,
      specifiedType: const FullType(num),
    );
    yield r'local_kwh';
    yield serializers.serialize(
      object.localKwh,
      specifiedType: const FullType(num),
    );
    yield r'self_consumption_rate';
    yield object.selfConsumptionRate == null
        ? null
        : serializers.serialize(
            object.selfConsumptionRate,
            specifiedType: const FullType.nullable(num),
          );
    yield r'amount_eur';
    yield serializers.serialize(
      object.amountEur,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConsumerSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConsumerSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'consumption_kwh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.consumptionKwh = valueDes;
          break;
        case r'local_kwh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.localKwh = valueDes;
          break;
        case r'self_consumption_rate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.selfConsumptionRate = valueDes;
          break;
        case r'amount_eur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amountEur = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConsumerSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConsumerSummaryBuilder();
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
