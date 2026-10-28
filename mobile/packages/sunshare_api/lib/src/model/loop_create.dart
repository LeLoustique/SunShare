//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sunshare_api/src/model/allocation_mode.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loop_create.g.dart';

/// LoopCreate
///
/// Properties:
/// * [name]
/// * [perimeterKm]
/// * [priceEurKwh]
/// * [commissionEurKwh]
/// * [allocationMode]
/// * [enedisOperationId]
@BuiltValue()
abstract class LoopCreate implements Built<LoopCreate, LoopCreateBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'perimeter_km')
  num? get perimeterKm;

  @BuiltValueField(wireName: r'price_eur_kwh')
  String get priceEurKwh;

  @BuiltValueField(wireName: r'commission_eur_kwh')
  String get commissionEurKwh;

  @BuiltValueField(wireName: r'allocation_mode')
  AllocationMode? get allocationMode;
  // enum allocationModeEnum {  static,  dynamic_default,  dynamic_custom,  };

  @BuiltValueField(wireName: r'enedis_operation_id')
  String? get enedisOperationId;

  LoopCreate._();

  factory LoopCreate([void updates(LoopCreateBuilder b)]) = _$LoopCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoopCreateBuilder b) => b..perimeterKm = 2;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoopCreate> get serializer => _$LoopCreateSerializer();
}

class _$LoopCreateSerializer implements PrimitiveSerializer<LoopCreate> {
  @override
  final Iterable<Type> types = const [LoopCreate, _$LoopCreate];

  @override
  final String wireName = r'LoopCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoopCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.perimeterKm != null) {
      yield r'perimeter_km';
      yield serializers.serialize(
        object.perimeterKm,
        specifiedType: const FullType(num),
      );
    }
    yield r'price_eur_kwh';
    yield serializers.serialize(
      object.priceEurKwh,
      specifiedType: const FullType(String),
    );
    yield r'commission_eur_kwh';
    yield serializers.serialize(
      object.commissionEurKwh,
      specifiedType: const FullType(String),
    );
    if (object.allocationMode != null) {
      yield r'allocation_mode';
      yield serializers.serialize(
        object.allocationMode,
        specifiedType: const FullType.nullable(AllocationMode),
      );
    }
    if (object.enedisOperationId != null) {
      yield r'enedis_operation_id';
      yield serializers.serialize(
        object.enedisOperationId,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LoopCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoopCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'commission_eur_kwh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.commissionEurKwh = valueDes;
          break;
        case r'allocation_mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AllocationMode),
          ) as AllocationMode?;
          if (valueDes == null) continue;
          result.allocationMode = valueDes;
          break;
        case r'enedis_operation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.enedisOperationId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoopCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoopCreateBuilder();
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
