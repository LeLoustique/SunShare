//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'join_request.g.dart';

/// JoinRequest
///
/// Properties:
/// * [meterId]
@BuiltValue()
abstract class JoinRequest implements Built<JoinRequest, JoinRequestBuilder> {
  @BuiltValueField(wireName: r'meter_id')
  String get meterId;

  JoinRequest._();

  factory JoinRequest([void updates(JoinRequestBuilder b)]) = _$JoinRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JoinRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JoinRequest> get serializer => _$JoinRequestSerializer();
}

class _$JoinRequestSerializer implements PrimitiveSerializer<JoinRequest> {
  @override
  final Iterable<Type> types = const [JoinRequest, _$JoinRequest];

  @override
  final String wireName = r'JoinRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JoinRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'meter_id';
    yield serializers.serialize(
      object.meterId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    JoinRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JoinRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'meter_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.meterId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  JoinRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JoinRequestBuilder();
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
