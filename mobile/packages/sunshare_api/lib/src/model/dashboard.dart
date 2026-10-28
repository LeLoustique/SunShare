//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sunshare_api/src/model/producer_summary.dart';
import 'package:sunshare_api/src/model/data_source.dart';
import 'package:sunshare_api/src/model/consumer_summary.dart';
import 'package:sunshare_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard.g.dart';

/// Dashboard
///
/// Properties:
/// * [period]
/// * [dataSource]
/// * [dataCompleteUntil]
/// * [consumer]
/// * [producer]
/// * [co2AvoidedKg]
/// * [co2KgPerKwh]
@BuiltValue()
abstract class Dashboard implements Built<Dashboard, DashboardBuilder> {
  @BuiltValueField(wireName: r'period')
  String get period;

  @BuiltValueField(wireName: r'data_source')
  DataSource? get dataSource;
  // enum dataSourceEnum {  enedis,  simulated,  };

  @BuiltValueField(wireName: r'data_complete_until')
  Date? get dataCompleteUntil;

  @BuiltValueField(wireName: r'consumer')
  ConsumerSummary? get consumer;

  @BuiltValueField(wireName: r'producer')
  ProducerSummary? get producer;

  @BuiltValueField(wireName: r'co2_avoided_kg')
  num get co2AvoidedKg;

  @BuiltValueField(wireName: r'co2_kg_per_kwh')
  num get co2KgPerKwh;

  Dashboard._();

  factory Dashboard([void updates(DashboardBuilder b)]) = _$Dashboard;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Dashboard> get serializer => _$DashboardSerializer();
}

class _$DashboardSerializer implements PrimitiveSerializer<Dashboard> {
  @override
  final Iterable<Type> types = const [Dashboard, _$Dashboard];

  @override
  final String wireName = r'Dashboard';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Dashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(String),
    );
    yield r'data_source';
    yield object.dataSource == null
        ? null
        : serializers.serialize(
            object.dataSource,
            specifiedType: const FullType.nullable(DataSource),
          );
    yield r'data_complete_until';
    yield object.dataCompleteUntil == null
        ? null
        : serializers.serialize(
            object.dataCompleteUntil,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'consumer';
    yield object.consumer == null
        ? null
        : serializers.serialize(
            object.consumer,
            specifiedType: const FullType.nullable(ConsumerSummary),
          );
    yield r'producer';
    yield object.producer == null
        ? null
        : serializers.serialize(
            object.producer,
            specifiedType: const FullType.nullable(ProducerSummary),
          );
    yield r'co2_avoided_kg';
    yield serializers.serialize(
      object.co2AvoidedKg,
      specifiedType: const FullType(num),
    );
    yield r'co2_kg_per_kwh';
    yield serializers.serialize(
      object.co2KgPerKwh,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Dashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DashboardBuilder result,
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
        case r'data_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DataSource),
          ) as DataSource?;
          if (valueDes == null) continue;
          result.dataSource = valueDes;
          break;
        case r'data_complete_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.dataCompleteUntil = valueDes;
          break;
        case r'consumer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ConsumerSummary),
          ) as ConsumerSummary?;
          if (valueDes == null) continue;
          result.consumer.replace(valueDes);
          break;
        case r'producer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProducerSummary),
          ) as ProducerSummary?;
          if (valueDes == null) continue;
          result.producer.replace(valueDes);
          break;
        case r'co2_avoided_kg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.co2AvoidedKg = valueDes;
          break;
        case r'co2_kg_per_kwh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.co2KgPerKwh = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Dashboard deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardBuilder();
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
