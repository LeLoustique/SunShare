// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'producer_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProducerSummary extends ProducerSummary {
  @override
  final num productionKwh;
  @override
  final num soldKwh;
  @override
  final num? localShare;
  @override
  final String commissionEur;
  @override
  final String netEur;

  factory _$ProducerSummary([void Function(ProducerSummaryBuilder)? updates]) =>
      (ProducerSummaryBuilder()..update(updates))._build();

  _$ProducerSummary._(
      {required this.productionKwh,
      required this.soldKwh,
      this.localShare,
      required this.commissionEur,
      required this.netEur})
      : super._();
  @override
  ProducerSummary rebuild(void Function(ProducerSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProducerSummaryBuilder toBuilder() => ProducerSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProducerSummary &&
        productionKwh == other.productionKwh &&
        soldKwh == other.soldKwh &&
        localShare == other.localShare &&
        commissionEur == other.commissionEur &&
        netEur == other.netEur;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productionKwh.hashCode);
    _$hash = $jc(_$hash, soldKwh.hashCode);
    _$hash = $jc(_$hash, localShare.hashCode);
    _$hash = $jc(_$hash, commissionEur.hashCode);
    _$hash = $jc(_$hash, netEur.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProducerSummary')
          ..add('productionKwh', productionKwh)
          ..add('soldKwh', soldKwh)
          ..add('localShare', localShare)
          ..add('commissionEur', commissionEur)
          ..add('netEur', netEur))
        .toString();
  }
}

class ProducerSummaryBuilder implements Builder<ProducerSummary, ProducerSummaryBuilder> {
  _$ProducerSummary? _$v;

  num? _productionKwh;
  num? get productionKwh => _$this._productionKwh;
  set productionKwh(num? productionKwh) => _$this._productionKwh = productionKwh;

  num? _soldKwh;
  num? get soldKwh => _$this._soldKwh;
  set soldKwh(num? soldKwh) => _$this._soldKwh = soldKwh;

  num? _localShare;
  num? get localShare => _$this._localShare;
  set localShare(num? localShare) => _$this._localShare = localShare;

  String? _commissionEur;
  String? get commissionEur => _$this._commissionEur;
  set commissionEur(String? commissionEur) => _$this._commissionEur = commissionEur;

  String? _netEur;
  String? get netEur => _$this._netEur;
  set netEur(String? netEur) => _$this._netEur = netEur;

  ProducerSummaryBuilder() {
    ProducerSummary._defaults(this);
  }

  ProducerSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productionKwh = $v.productionKwh;
      _soldKwh = $v.soldKwh;
      _localShare = $v.localShare;
      _commissionEur = $v.commissionEur;
      _netEur = $v.netEur;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProducerSummary other) {
    _$v = other as _$ProducerSummary;
  }

  @override
  void update(void Function(ProducerSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProducerSummary build() => _build();

  _$ProducerSummary _build() {
    final _$result = _$v ??
        _$ProducerSummary._(
          productionKwh: BuiltValueNullFieldError.checkNotNull(
              productionKwh, r'ProducerSummary', 'productionKwh'),
          soldKwh: BuiltValueNullFieldError.checkNotNull(soldKwh, r'ProducerSummary', 'soldKwh'),
          localShare: localShare,
          commissionEur: BuiltValueNullFieldError.checkNotNull(
              commissionEur, r'ProducerSummary', 'commissionEur'),
          netEur: BuiltValueNullFieldError.checkNotNull(netEur, r'ProducerSummary', 'netEur'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
