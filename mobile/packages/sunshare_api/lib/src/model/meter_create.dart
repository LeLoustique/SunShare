//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sunshare_api/src/model/meter_direction.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'meter_create.g.dart';

/// MeterCreate
///
/// Properties:
/// * [prm]
/// * [direction]
/// * [address]
/// * [peakKw]
@BuiltValue()
abstract class MeterCreate implements Built<MeterCreate, MeterCreateBuilder> {
  @BuiltValueField(wireName: r'prm')
  String get prm;

  @BuiltValueField(wireName: r'direction')
  MeterDirection get direction;
  // enum directionEnum {  consumption,  production,  };

  @BuiltValueField(wireName: r'address')
  String get address;

  @BuiltValueField(wireName: r'peak_kw')
  num? get peakKw;

  MeterCreate._();

  factory MeterCreate([void updates(MeterCreateBuilder b)]) = _$MeterCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MeterCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MeterCreate> get serializer => _$MeterCreateSerializer();
}

class _$MeterCreateSerializer implements PrimitiveSerializer<MeterCreate> {
  @override
  final Iterable<Type> types = const [MeterCreate, _$MeterCreate];

  @override
  final String wireName = r'MeterCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MeterCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(String),
    );
    if (object.peakKw != null) {
      yield r'peak_kw';
      yield serializers.serialize(
        object.peakKw,
        specifiedType: const FullType.nullable(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MeterCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MeterCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
          break;
        case r'peak_kw':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.peakKw = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MeterCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MeterCreateBuilder();
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
