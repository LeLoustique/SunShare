// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumer_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConsumerSummary extends ConsumerSummary {
  @override
  final num consumptionKwh;
  @override
  final num localKwh;
  @override
  final num? selfConsumptionRate;
  @override
  final String amountEur;

  factory _$ConsumerSummary([void Function(ConsumerSummaryBuilder)? updates]) =>
      (ConsumerSummaryBuilder()..update(updates))._build();

  _$ConsumerSummary._(
      {required this.consumptionKwh,
      required this.localKwh,
      this.selfConsumptionRate,
      required this.amountEur})
      : super._();
  @override
  ConsumerSummary rebuild(void Function(ConsumerSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConsumerSummaryBuilder toBuilder() => ConsumerSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConsumerSummary &&
        consumptionKwh == other.consumptionKwh &&
        localKwh == other.localKwh &&
        selfConsumptionRate == other.selfConsumptionRate &&
        amountEur == other.amountEur;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, consumptionKwh.hashCode);
    _$hash = $jc(_$hash, localKwh.hashCode);
    _$hash = $jc(_$hash, selfConsumptionRate.hashCode);
    _$hash = $jc(_$hash, amountEur.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConsumerSummary')
          ..add('consumptionKwh', consumptionKwh)
          ..add('localKwh', localKwh)
          ..add('selfConsumptionRate', selfConsumptionRate)
          ..add('amountEur', amountEur))
        .toString();
  }
}

class ConsumerSummaryBuilder implements Builder<ConsumerSummary, ConsumerSummaryBuilder> {
  _$ConsumerSummary? _$v;

  num? _consumptionKwh;
  num? get consumptionKwh => _$this._consumptionKwh;
  set consumptionKwh(num? consumptionKwh) => _$this._consumptionKwh = consumptionKwh;

  num? _localKwh;
  num? get localKwh => _$this._localKwh;
  set localKwh(num? localKwh) => _$this._localKwh = localKwh;

  num? _selfConsumptionRate;
  num? get selfConsumptionRate => _$this._selfConsumptionRate;
  set selfConsumptionRate(num? selfConsumptionRate) =>
      _$this._selfConsumptionRate = selfConsumptionRate;

  String? _amountEur;
  String? get amountEur => _$this._amountEur;
  set amountEur(String? amountEur) => _$this._amountEur = amountEur;

  ConsumerSummaryBuilder() {
    ConsumerSummary._defaults(this);
  }

  ConsumerSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _consumptionKwh = $v.consumptionKwh;
      _localKwh = $v.localKwh;
      _selfConsumptionRate = $v.selfConsumptionRate;
      _amountEur = $v.amountEur;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConsumerSummary other) {
    _$v = other as _$ConsumerSummary;
  }

  @override
  void update(void Function(ConsumerSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConsumerSummary build() => _build();

  _$ConsumerSummary _build() {
    final _$result = _$v ??
        _$ConsumerSummary._(
          consumptionKwh: BuiltValueNullFieldError.checkNotNull(
              consumptionKwh, r'ConsumerSummary', 'consumptionKwh'),
          localKwh: BuiltValueNullFieldError.checkNotNull(localKwh, r'ConsumerSummary', 'localKwh'),
          selfConsumptionRate: selfConsumptionRate,
          amountEur:
              BuiltValueNullFieldError.checkNotNull(amountEur, r'ConsumerSummary', 'amountEur'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
