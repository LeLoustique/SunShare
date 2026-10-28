//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sunshare_api/src/model/loop_stats.dart';
import 'package:sunshare_api/src/model/loop_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loop_out.g.dart';

/// LoopOut
///
/// Properties:
/// * [id]
/// * [name]
/// * [perimeterKm]
/// * [priceEurKwh]
/// * [status]
/// * [stats]
@BuiltValue()
abstract class LoopOut implements Built<LoopOut, LoopOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'perimeter_km')
  num get perimeterKm;

  @BuiltValueField(wireName: r'price_eur_kwh')
  String get priceEurKwh;

  @BuiltValueField(wireName: r'status')
  LoopStatus get status;
  // enum statusEnum {  open,  closed,  };

  @BuiltValueField(wireName: r'stats')
  LoopStats get stats;

  LoopOut._();

  factory LoopOut([void updates(LoopOutBuilder b)]) = _$LoopOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoopOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoopOut> get serializer => _$LoopOutSerializer();
}

class _$LoopOutSerializer implements PrimitiveSerializer<LoopOut> {
  @override
  final Iterable<Type> types = const [LoopOut, _$LoopOut];

  @override
  final String wireName = r'LoopOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoopOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'perimeter_km';
    yield serializers.serialize(
      object.perimeterKm,
      specifiedType: const FullType(num),
    );
    yield r'price_eur_kwh';
    yield serializers.serialize(
      object.priceEurKwh,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(LoopStatus),
    );
    yield r'stats';
    yield serializers.serialize(
      object.stats,
      specifiedType: const FullType(LoopStats),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoopOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoopOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'perimeter_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.perimeterKm = valueDes;
          break;
        case r'price_eur_kwh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.priceEurKwh = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LoopStatus),
          ) as LoopStatus;
          result.status = valueDes;
          break;
        case r'stats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LoopStats),
          ) as LoopStats;
          result.stats.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoopOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoopOutBuilder();
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
