//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sunshare_api/src/model/allocation_mode.dart';
import 'package:sunshare_api/src/model/loop_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loop_update.g.dart';

/// Champs absents : inchangés.
///
/// Properties:
/// * [name]
/// * [perimeterKm]
/// * [priceEurKwh]
/// * [commissionEurKwh]
/// * [allocationMode]
/// * [status]
/// * [enedisOperationId]
@BuiltValue()
abstract class LoopUpdate implements Built<LoopUpdate, LoopUpdateBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'perimeter_km')
  num? get perimeterKm;

  @BuiltValueField(wireName: r'price_eur_kwh')
  String? get priceEurKwh;

  @BuiltValueField(wireName: r'commission_eur_kwh')
  String? get commissionEurKwh;

  @BuiltValueField(wireName: r'allocation_mode')
  AllocationMode? get allocationMode;
  // enum allocationModeEnum {  static,  dynamic_default,  dynamic_custom,  };

  @BuiltValueField(wireName: r'status')
  LoopStatus? get status;
  // enum statusEnum {  open,  closed,  };

  @BuiltValueField(wireName: r'enedis_operation_id')
  String? get enedisOperationId;

  LoopUpdate._();

  factory LoopUpdate([void updates(LoopUpdateBuilder b)]) = _$LoopUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoopUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoopUpdate> get serializer => _$LoopUpdateSerializer();
}

class _$LoopUpdateSerializer implements PrimitiveSerializer<LoopUpdate> {
  @override
  final Iterable<Type> types = const [LoopUpdate, _$LoopUpdate];

  @override
  final String wireName = r'LoopUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoopUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.perimeterKm != null) {
      yield r'perimeter_km';
      yield serializers.serialize(
        object.perimeterKm,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.priceEurKwh != null) {
      yield r'price_eur_kwh';
      yield serializers.serialize(
        object.priceEurKwh,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.commissionEurKwh != null) {
      yield r'commission_eur_kwh';
      yield serializers.serialize(
        object.commissionEurKwh,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.allocationMode != null) {
      yield r'allocation_mode';
      yield serializers.serialize(
        object.allocationMode,
        specifiedType: const FullType.nullable(AllocationMode),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType.nullable(LoopStatus),
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
    LoopUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoopUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'perimeter_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.perimeterKm = valueDes;
          break;
        case r'price_eur_kwh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.priceEurKwh = valueDes;
          break;
        case r'commission_eur_kwh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(LoopStatus),
          ) as LoopStatus?;
          if (valueDes == null) continue;
          result.status = valueDes;
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
  LoopUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoopUpdateBuilder();
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
