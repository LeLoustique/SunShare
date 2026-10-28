//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'issue_out.g.dart';

/// IssueOut
///
/// Properties:
/// * [period]
/// * [issued]
/// * [firstNumber]
/// * [lastNumber]
@BuiltValue()
abstract class IssueOut implements Built<IssueOut, IssueOutBuilder> {
  @BuiltValueField(wireName: r'period')
  String get period;

  @BuiltValueField(wireName: r'issued')
  int get issued;

  @BuiltValueField(wireName: r'first_number')
  String get firstNumber;

  @BuiltValueField(wireName: r'last_number')
  String get lastNumber;

  IssueOut._();

  factory IssueOut([void updates(IssueOutBuilder b)]) = _$IssueOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IssueOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IssueOut> get serializer => _$IssueOutSerializer();
}

class _$IssueOutSerializer implements PrimitiveSerializer<IssueOut> {
  @override
  final Iterable<Type> types = const [IssueOut, _$IssueOut];

  @override
  final String wireName = r'IssueOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IssueOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(String),
    );
    yield r'issued';
    yield serializers.serialize(
      object.issued,
      specifiedType: const FullType(int),
    );
    yield r'first_number';
    yield serializers.serialize(
      object.firstNumber,
      specifiedType: const FullType(String),
    );
    yield r'last_number';
    yield serializers.serialize(
      object.lastNumber,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    IssueOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IssueOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.period = valueDes;
          break;
        case r'issued':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.issued = valueDes;
          break;
        case r'first_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstNumber = valueDes;
          break;
        case r'last_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lastNumber = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IssueOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IssueOutBuilder();
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
