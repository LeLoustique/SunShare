// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curve_step.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CurveStep extends CurveStep {
  @override
  final DateTime ts;
  @override
  final num? consumptionKw;
  @override
  final num? productionKw;
  @override
  final num receivedKwh;
  @override
  final num soldKwh;

  factory _$CurveStep([void Function(CurveStepBuilder)? updates]) =>
      (CurveStepBuilder()..update(updates))._build();

  _$CurveStep._(
      {required this.ts,
      this.consumptionKw,
      this.productionKw,
      required this.receivedKwh,
      required this.soldKwh})
      : super._();
  @override
  CurveStep rebuild(void Function(CurveStepBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CurveStepBuilder toBuilder() => CurveStepBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CurveStep &&
        ts == other.ts &&
        consumptionKw == other.consumptionKw &&
        productionKw == other.productionKw &&
        receivedKwh == other.receivedKwh &&
        soldKwh == other.soldKwh;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ts.hashCode);
    _$hash = $jc(_$hash, consumptionKw.hashCode);
    _$hash = $jc(_$hash, productionKw.hashCode);
    _$hash = $jc(_$hash, receivedKwh.hashCode);
    _$hash = $jc(_$hash, soldKwh.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CurveStep')
          ..add('ts', ts)
          ..add('consumptionKw', consumptionKw)
          ..add('productionKw', productionKw)
          ..add('receivedKwh', receivedKwh)
          ..add('soldKwh', soldKwh))
        .toString();
  }
}

class CurveStepBuilder implements Builder<CurveStep, CurveStepBuilder> {
  _$CurveStep? _$v;

  DateTime? _ts;
  DateTime? get ts => _$this._ts;
  set ts(DateTime? ts) => _$this._ts = ts;

  num? _consumptionKw;
  num? get consumptionKw => _$this._consumptionKw;
  set consumptionKw(num? consumptionKw) => _$this._consumptionKw = consumptionKw;

  num? _productionKw;
  num? get productionKw => _$this._productionKw;
  set productionKw(num? productionKw) => _$this._productionKw = productionKw;

  num? _receivedKwh;
  num? get receivedKwh => _$this._receivedKwh;
  set receivedKwh(num? receivedKwh) => _$this._receivedKwh = receivedKwh;

  num? _soldKwh;
  num? get soldKwh => _$this._soldKwh;
  set soldKwh(num? soldKwh) => _$this._soldKwh = soldKwh;

  CurveStepBuilder() {
    CurveStep._defaults(this);
  }

  CurveStepBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ts = $v.ts;
      _consumptionKw = $v.consumptionKw;
      _productionKw = $v.productionKw;
      _receivedKwh = $v.receivedKwh;
      _soldKwh = $v.soldKwh;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CurveStep other) {
    _$v = other as _$CurveStep;
  }

  @override
  void update(void Function(CurveStepBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CurveStep build() => _build();

  _$CurveStep _build() {
    final _$result = _$v ??
        _$CurveStep._(
          ts: BuiltValueNullFieldError.checkNotNull(ts, r'CurveStep', 'ts'),
          consumptionKw: consumptionKw,
          productionKw: productionKw,
          receivedKwh:
              BuiltValueNullFieldError.checkNotNull(receivedKwh, r'CurveStep', 'receivedKwh'),
          soldKwh: BuiltValueNullFieldError.checkNotNull(soldKwh, r'CurveStep', 'soldKwh'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
