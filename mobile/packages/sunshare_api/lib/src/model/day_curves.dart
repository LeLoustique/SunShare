//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sunshare_api/src/model/data_source.dart';
import 'package:sunshare_api/src/model/curve_step.dart';
import 'package:sunshare_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'day_curves.g.dart';

/// DayCurves
///
/// Properties:
/// * [day]
/// * [dataSource]
/// * [steps]
@BuiltValue()
abstract class DayCurves implements Built<DayCurves, DayCurvesBuilder> {
  @BuiltValueField(wireName: r'day')
  Date get day;

  @BuiltValueField(wireName: r'data_source')
  DataSource? get dataSource;
  // enum dataSourceEnum {  enedis,  simulated,  };

  @BuiltValueField(wireName: r'steps')
  BuiltList<CurveStep> get steps;

  DayCurves._();

  factory DayCurves([void updates(DayCurvesBuilder b)]) = _$DayCurves;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DayCurvesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DayCurves> get serializer => _$DayCurvesSerializer();
}

class _$DayCurvesSerializer implements PrimitiveSerializer<DayCurves> {
  @override
  final Iterable<Type> types = const [DayCurves, _$DayCurves];

  @override
  final String wireName = r'DayCurves';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DayCurves object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'day';
    yield serializers.serialize(
      object.day,
      specifiedType: const FullType(Date),
    );
    yield r'data_source';
    yield object.dataSource == null
        ? null
        : serializers.serialize(
            object.dataSource,
            specifiedType: const FullType.nullable(DataSource),
          );
    yield r'steps';
    yield serializers.serialize(
      object.steps,
      specifiedType: const FullType(BuiltList, [FullType(CurveStep)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DayCurves object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DayCurvesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'day':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.day = valueDes;
          break;
        case r'data_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DataSource),
          ) as DataSource?;
          if (valueDes == null) continue;
          result.dataSource = valueDes;
          break;
        case r'steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CurveStep)]),
          ) as BuiltList<CurveStep>;
          result.steps.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DayCurves deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DayCurvesBuilder();
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
