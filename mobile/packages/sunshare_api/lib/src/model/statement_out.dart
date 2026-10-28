//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sunshare_api/src/model/statement_status.dart';
import 'package:sunshare_api/src/model/meter_direction.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'statement_out.g.dart';

/// Relevé : facture (consumption) ou reversement (production). Montants exacts en chaîne.
///
/// Properties:
/// * [id]
/// * [number]
/// * [loopId]
/// * [loopName]
/// * [period]
/// * [direction]
/// * [status]
/// * [kwh]
/// * [priceEurKwh]
/// * [commissionEurKwh]
/// * [networkFeeEurKwh]
/// * [grossEur]
/// * [networkFeeEur]
/// * [commissionEur]
/// * [netEur]
/// * [issuedAt]
@BuiltValue()
abstract class StatementOut implements Built<StatementOut, StatementOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String? get number;

  @BuiltValueField(wireName: r'loop_id')
  String get loopId;

  @BuiltValueField(wireName: r'loop_name')
  String get loopName;

  @BuiltValueField(wireName: r'period')
  String get period;

  @BuiltValueField(wireName: r'direction')
  MeterDirection get direction;
  // enum directionEnum {  consumption,  production,  };

  @BuiltValueField(wireName: r'status')
  StatementStatus get status;
  // enum statusEnum {  draft,  issued,  };

  @BuiltValueField(wireName: r'kwh')
  num get kwh;

  @BuiltValueField(wireName: r'price_eur_kwh')
  String get priceEurKwh;

  @BuiltValueField(wireName: r'commission_eur_kwh')
  String get commissionEurKwh;

  @BuiltValueField(wireName: r'network_fee_eur_kwh')
  String get networkFeeEurKwh;

  @BuiltValueField(wireName: r'gross_eur')
  String get grossEur;

  @BuiltValueField(wireName: r'network_fee_eur')
  String get networkFeeEur;

  @BuiltValueField(wireName: r'commission_eur')
  String get commissionEur;

  @BuiltValueField(wireName: r'net_eur')
  String get netEur;

  @BuiltValueField(wireName: r'issued_at')
  DateTime? get issuedAt;

  StatementOut._();

  factory StatementOut([void updates(StatementOutBuilder b)]) = _$StatementOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StatementOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StatementOut> get serializer => _$StatementOutSerializer();
}

class _$StatementOutSerializer implements PrimitiveSerializer<StatementOut> {
  @override
  final Iterable<Type> types = const [StatementOut, _$StatementOut];

  @override
  final String wireName = r'StatementOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StatementOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield object.number == null
        ? null
        : serializers.serialize(
            object.number,
            specifiedType: const FullType.nullable(String),
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
    yield r'period';
    yield serializers.serialize(
      object.period,
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
      specifiedType: const FullType(StatementStatus),
    );
    yield r'kwh';
    yield serializers.serialize(
      object.kwh,
      specifiedType: const FullType(num),
    );
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
    yield r'network_fee_eur_kwh';
    yield serializers.serialize(
      object.networkFeeEurKwh,
      specifiedType: const FullType(String),
    );
    yield r'gross_eur';
    yield serializers.serialize(
      object.grossEur,
      specifiedType: const FullType(String),
    );
    yield r'network_fee_eur';
    yield serializers.serialize(
      object.networkFeeEur,
      specifiedType: const FullType(String),
    );
    yield r'commission_eur';
    yield serializers.serialize(
      object.commissionEur,
      specifiedType: const FullType(String),
    );
    yield r'net_eur';
    yield serializers.serialize(
      object.netEur,
      specifiedType: const FullType(String),
    );
    yield r'issued_at';
    yield object.issuedAt == null
        ? null
        : serializers.serialize(
            object.issuedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    StatementOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StatementOutBuilder result,
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
        case r'number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.number = valueDes;
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
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.period = valueDes;
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
            specifiedType: const FullType(StatementStatus),
          ) as StatementStatus;
          result.status = valueDes;
          break;
        case r'kwh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.kwh = valueDes;
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
        case r'network_fee_eur_kwh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.networkFeeEurKwh = valueDes;
          break;
        case r'gross_eur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.grossEur = valueDes;
          break;
        case r'network_fee_eur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.networkFeeEur = valueDes;
          break;
        case r'commission_eur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.commissionEur = valueDes;
          break;
        case r'net_eur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.netEur = valueDes;
          break;
        case r'issued_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.issuedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StatementOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StatementOutBuilder();
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
