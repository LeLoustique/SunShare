//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loop_stats.g.dart';

/// Chiffres agrégés : jamais d'information individuelle sur les autres membres.
///
/// Properties:
/// * [memberCount]
/// * [producerCount]
/// * [consumerCount]
/// * [totalPeakKw]
/// * [diameterKm]
@BuiltValue()
abstract class LoopStats implements Built<LoopStats, LoopStatsBuilder> {
  @BuiltValueField(wireName: r'member_count')
  int get memberCount;

  @BuiltValueField(wireName: r'producer_count')
  int get producerCount;

  @BuiltValueField(wireName: r'consumer_count')
  int get consumerCount;

  @BuiltValueField(wireName: r'total_peak_kw')
  num get totalPeakKw;

  @BuiltValueField(wireName: r'diameter_km')
  num get diameterKm;

  LoopStats._();

  factory LoopStats([void updates(LoopStatsBuilder b)]) = _$LoopStats;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoopStatsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoopStats> get serializer => _$LoopStatsSerializer();
}

class _$LoopStatsSerializer implements PrimitiveSerializer<LoopStats> {
  @override
  final Iterable<Type> types = const [LoopStats, _$LoopStats];

  @override
  final String wireName = r'LoopStats';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoopStats object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'member_count';
    yield serializers.serialize(
      object.memberCount,
      specifiedType: const FullType(int),
    );
    yield r'producer_count';
    yield serializers.serialize(
      object.producerCount,
      specifiedType: const FullType(int),
    );
    yield r'consumer_count';
    yield serializers.serialize(
      object.consumerCount,
      specifiedType: const FullType(int),
    );
    yield r'total_peak_kw';
    yield serializers.serialize(
      object.totalPeakKw,
      specifiedType: const FullType(num),
    );
    yield r'diameter_km';
    yield serializers.serialize(
      object.diameterKm,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoopStats object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoopStatsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'member_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberCount = valueDes;
          break;
        case r'producer_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.producerCount = valueDes;
          break;
        case r'consumer_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.consumerCount = valueDes;
          break;
        case r'total_peak_kw':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.totalPeakKw = valueDes;
          break;
        case r'diameter_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.diameterKm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoopStats deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoopStatsBuilder();
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
