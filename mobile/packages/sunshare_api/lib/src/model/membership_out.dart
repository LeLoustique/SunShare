//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sunshare_api/src/model/meter_direction.dart';
import 'package:sunshare_api/src/model/membership_status.dart';
import 'package:sunshare_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_out.g.dart';

/// MembershipOut
///
/// Properties:
/// * [id]
/// * [loopId]
/// * [loopName]
/// * [meterId]
/// * [prm]
/// * [direction]
/// * [status]
/// * [requestedAt]
/// * [joinedAt]
/// * [leftAt]
@BuiltValue()
abstract class MembershipOut implements Built<MembershipOut, MembershipOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'loop_id')
  String get loopId;

  @BuiltValueField(wireName: r'loop_name')
  String get loopName;

  @BuiltValueField(wireName: r'meter_id')
  String get meterId;

  @BuiltValueField(wireName: r'prm')
  String get prm;

  @BuiltValueField(wireName: r'direction')
  MeterDirection get direction;
  // enum directionEnum {  consumption,  production,  };

  @BuiltValueField(wireName: r'status')
  MembershipStatus get status;
  // enum statusEnum {  pending,  active,  rejected,  left,  };

  @BuiltValueField(wireName: r'requested_at')
  DateTime get requestedAt;

  @BuiltValueField(wireName: r'joined_at')
  Date? get joinedAt;

  @BuiltValueField(wireName: r'left_at')
  Date? get leftAt;

  MembershipOut._();

  factory MembershipOut([void updates(MembershipOutBuilder b)]) = _$MembershipOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MembershipOut> get serializer => _$MembershipOutSerializer();
}

class _$MembershipOutSerializer implements PrimitiveSerializer<MembershipOut> {
  @override
  final Iterable<Type> types = const [MembershipOut, _$MembershipOut];

  @override
  final String wireName = r'MembershipOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MembershipOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'meter_id';
    yield serializers.serialize(
      object.meterId,
      specifiedType: const FullType(String),
    );
    yield r'prm';
    yield serializers.serialize(
      object.prm,
      specifiedType: const FullType(String),
    );
    yield r'direction';
    yield serializers.serialize(
      object.direction,
      specifiedType: const FullType(MeterDirection),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MembershipStatus),
    );
    yield r'requested_at';
    yield serializers.serialize(
      object.requestedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'joined_at';
    yield object.joinedAt == null
        ? null
        : serializers.serialize(
            object.joinedAt,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'left_at';
    yield object.leftAt == null
        ? null
        : serializers.serialize(
            object.leftAt,
            specifiedType: const FullType.nullable(Date),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MembershipOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipOutBuilder result,
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
        case r'meter_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.meterId = valueDes;
          break;
        case r'prm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.prm = valueDes;
          break;
        case r'direction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MeterDirection),
          ) as MeterDirection;
          result.direction = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MembershipStatus),
          ) as MembershipStatus;
          result.status = valueDes;
          break;
        case r'requested_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.requestedAt = valueDes;
          break;
        case r'joined_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.joinedAt = valueDes;
          break;
        case r'left_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.leftAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MembershipOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipOutBuilder();
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
