//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sunshare_api/src/model/loop_stats.dart';
import 'package:sunshare_api/src/model/allocation_mode.dart';
import 'package:sunshare_api/src/model/loop_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_loop_out.g.dart';

/// AdminLoopOut
///
/// Properties:
/// * [id]
/// * [name]
/// * [perimeterKm]
/// * [priceEurKwh]
/// * [status]
/// * [stats]
/// * [commissionEurKwh]
/// * [allocationMode]
/// * [enedisOperationId]
/// * [pendingCount]
/// * [createdAt]
@BuiltValue()
abstract class AdminLoopOut implements Built<AdminLoopOut, AdminLoopOutBuilder> {
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

  @BuiltValueField(wireName: r'commission_eur_kwh')
  String get commissionEurKwh;

  @BuiltValueField(wireName: r'allocation_mode')
  AllocationMode get allocationMode;
  // enum allocationModeEnum {  static,  dynamic_default,  dynamic_custom,  };

  @BuiltValueField(wireName: r'enedis_operation_id')
  String? get enedisOperationId;

  @BuiltValueField(wireName: r'pending_count')
  int get pendingCount;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  AdminLoopOut._();

  factory AdminLoopOut([void updates(AdminLoopOutBuilder b)]) = _$AdminLoopOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminLoopOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminLoopOut> get serializer => _$AdminLoopOutSerializer();
}

class _$AdminLoopOutSerializer implements PrimitiveSerializer<AdminLoopOut> {
  @override
  final Iterable<Type> types = const [AdminLoopOut, _$AdminLoopOut];

  @override
  final String wireName = r'AdminLoopOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminLoopOut object, {
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
    yield r'commission_eur_kwh';
    yield serializers.serialize(
      object.commissionEurKwh,
      specifiedType: const FullType(String),
    );
    yield r'allocation_mode';
    yield serializers.serialize(
      object.allocationMode,
      specifiedType: const FullType(AllocationMode),
    );
    yield r'enedis_operation_id';
    yield object.enedisOperationId == null
        ? null
        : serializers.serialize(
            object.enedisOperationId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'pending_count';
    yield serializers.serialize(
      object.pendingCount,
      specifiedType: const FullType(int),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminLoopOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminLoopOutBuilder result,
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
            specifiedType: const FullType(AllocationMode),
          ) as AllocationMode;
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
        case r'pending_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingCount = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminLoopOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminLoopOutBuilder();
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
