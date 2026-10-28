//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'producer_summary.g.dart';

/// ProducerSummary
///
/// Properties:
/// * [productionKwh]
/// * [soldKwh]
/// * [localShare]
/// * [commissionEur]
/// * [netEur]
@BuiltValue()
abstract class ProducerSummary implements Built<ProducerSummary, ProducerSummaryBuilder> {
  @BuiltValueField(wireName: r'production_kwh')
  num get productionKwh;

  @BuiltValueField(wireName: r'sold_kwh')
  num get soldKwh;

  @BuiltValueField(wireName: r'local_share')
  num? get localShare;

  @BuiltValueField(wireName: r'commission_eur')
  String get commissionEur;

  @BuiltValueField(wireName: r'net_eur')
  String get netEur;

  ProducerSummary._();

  factory ProducerSummary([void updates(ProducerSummaryBuilder b)]) = _$ProducerSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProducerSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProducerSummary> get serializer => _$ProducerSummarySerializer();
}

class _$ProducerSummarySerializer implements PrimitiveSerializer<ProducerSummary> {
  @override
  final Iterable<Type> types = const [ProducerSummary, _$ProducerSummary];

  @override
  final String wireName = r'ProducerSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProducerSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'production_kwh';
    yield serializers.serialize(
      object.productionKwh,
      specifiedType: const FullType(num),
    );
    yield r'sold_kwh';
    yield serializers.serialize(
      object.soldKwh,
      specifiedType: const FullType(num),
    );
    yield r'local_share';
    yield object.localShare == null
        ? null
        : serializers.serialize(
            object.localShare,
            specifiedType: const FullType.nullable(num),
          );
    yield r'commission_eur';
    yield serializers.serialize(
      object.commissionEur,
      specifiedType: const FullType(String),
    );
    yield r'net_eur';
    yield serializers.serialize(
      object.netEur,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProducerSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProducerSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'production_kwh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.productionKwh = valueDes;
          break;
        case r'sold_kwh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.soldKwh = valueDes;
          break;
        case r'local_share':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.localShare = valueDes;
          break;
        case r'commission_eur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.commissionEur = valueDes;
          break;
        case r'net_eur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.netEur = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProducerSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProducerSummaryBuilder();
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
