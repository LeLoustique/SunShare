//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'available_loop.g.dart';

/// AvailableLoop
///
/// Properties:
/// * [id]
/// * [name]
/// * [perimeterKm]
/// * [priceEurKwh]
/// * [memberCount]
/// * [joinableMeterIds]
@BuiltValue()
abstract class AvailableLoop implements Built<AvailableLoop, AvailableLoopBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'perimeter_km')
  num get perimeterKm;

  @BuiltValueField(wireName: r'price_eur_kwh')
  String get priceEurKwh;

  @BuiltValueField(wireName: r'member_count')
  int get memberCount;

  @BuiltValueField(wireName: r'joinable_meter_ids')
  BuiltList<String> get joinableMeterIds;

  AvailableLoop._();

  factory AvailableLoop([void updates(AvailableLoopBuilder b)]) = _$AvailableLoop;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AvailableLoopBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AvailableLoop> get serializer => _$AvailableLoopSerializer();
}

class _$AvailableLoopSerializer implements PrimitiveSerializer<AvailableLoop> {
  @override
  final Iterable<Type> types = const [AvailableLoop, _$AvailableLoop];

  @override
  final String wireName = r'AvailableLoop';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AvailableLoop object, {
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
    yield r'member_count';
    yield serializers.serialize(
      object.memberCount,
      specifiedType: const FullType(int),
    );
    yield r'joinable_meter_ids';
    yield serializers.serialize(
      object.joinableMeterIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AvailableLoop object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AvailableLoopBuilder result,
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
        case r'member_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberCount = valueDes;
          break;
        case r'joinable_meter_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.joinableMeterIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AvailableLoop deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AvailableLoopBuilder();
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
