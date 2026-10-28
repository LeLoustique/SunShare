//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sunshare_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'approve_request.g.dart';

/// Date d'entrée dans l'opération, communiquée à Enedis.
///
/// Properties:
/// * [joinedAt]
@BuiltValue()
abstract class ApproveRequest implements Built<ApproveRequest, ApproveRequestBuilder> {
  @BuiltValueField(wireName: r'joined_at')
  Date get joinedAt;

  ApproveRequest._();

  factory ApproveRequest([void updates(ApproveRequestBuilder b)]) = _$ApproveRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApproveRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApproveRequest> get serializer => _$ApproveRequestSerializer();
}

class _$ApproveRequestSerializer implements PrimitiveSerializer<ApproveRequest> {
  @override
  final Iterable<Type> types = const [ApproveRequest, _$ApproveRequest];

  @override
  final String wireName = r'ApproveRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApproveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'joined_at';
    yield serializers.serialize(
      object.joinedAt,
      specifiedType: const FullType(Date),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApproveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApproveRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'joined_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.joinedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApproveRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApproveRequestBuilder();
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
