//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'curve_step.g.dart';

/// Un pas de 30 min. Puissances en kW (null : pas de compteur de ce sens ou pas de mesure).
///
/// Properties:
/// * [ts]
/// * [consumptionKw]
/// * [productionKw]
/// * [receivedKwh]
/// * [soldKwh]
@BuiltValue()
abstract class CurveStep implements Built<CurveStep, CurveStepBuilder> {
  @BuiltValueField(wireName: r'ts')
  DateTime get ts;

  @BuiltValueField(wireName: r'consumption_kw')
  num? get consumptionKw;

  @BuiltValueField(wireName: r'production_kw')
  num? get productionKw;

  @BuiltValueField(wireName: r'received_kwh')
  num get receivedKwh;

  @BuiltValueField(wireName: r'sold_kwh')
  num get soldKwh;

  CurveStep._();

  factory CurveStep([void updates(CurveStepBuilder b)]) = _$CurveStep;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CurveStepBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CurveStep> get serializer => _$CurveStepSerializer();
}

class _$CurveStepSerializer implements PrimitiveSerializer<CurveStep> {
  @override
  final Iterable<Type> types = const [CurveStep, _$CurveStep];

  @override
  final String wireName = r'CurveStep';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CurveStep object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ts';
    yield serializers.serialize(
      object.ts,
      specifiedType: const FullType(DateTime),
    );
    yield r'consumption_kw';
    yield object.consumptionKw == null
        ? null
        : serializers.serialize(
            object.consumptionKw,
            specifiedType: const FullType.nullable(num),
          );
    yield r'production_kw';
    yield object.productionKw == null
        ? null
        : serializers.serialize(
            object.productionKw,
            specifiedType: const FullType.nullable(num),
          );
    yield r'received_kwh';
    yield serializers.serialize(
      object.receivedKwh,
      specifiedType: const FullType(num),
    );
    yield r'sold_kwh';
    yield serializers.serialize(
      object.soldKwh,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CurveStep object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CurveStepBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.ts = valueDes;
          break;
        case r'consumption_kw':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.consumptionKw = valueDes;
          break;
        case r'production_kw':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.productionKw = valueDes;
          break;
        case r'received_kwh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.receivedKwh = valueDes;
          break;
        case r'sold_kwh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.soldKwh = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CurveStep deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CurveStepBuilder();
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
