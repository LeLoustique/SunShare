// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoopUpdate extends LoopUpdate {
  @override
  final String? name;
  @override
  final num? perimeterKm;
  @override
  final String? priceEurKwh;
  @override
  final String? commissionEurKwh;
  @override
  final AllocationMode? allocationMode;
  @override
  final LoopStatus? status;
  @override
  final String? enedisOperationId;

  factory _$LoopUpdate([void Function(LoopUpdateBuilder)? updates]) =>
      (LoopUpdateBuilder()..update(updates))._build();

  _$LoopUpdate._(
      {this.name,
      this.perimeterKm,
      this.priceEurKwh,
      this.commissionEurKwh,
      this.allocationMode,
      this.status,
      this.enedisOperationId})
      : super._();
  @override
  LoopUpdate rebuild(void Function(LoopUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoopUpdateBuilder toBuilder() => LoopUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoopUpdate &&
        name == other.name &&
        perimeterKm == other.perimeterKm &&
        priceEurKwh == other.priceEurKwh &&
        commissionEurKwh == other.commissionEurKwh &&
        allocationMode == other.allocationMode &&
        status == other.status &&
        enedisOperationId == other.enedisOperationId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, perimeterKm.hashCode);
    _$hash = $jc(_$hash, priceEurKwh.hashCode);
    _$hash = $jc(_$hash, commissionEurKwh.hashCode);
    _$hash = $jc(_$hash, allocationMode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, enedisOperationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoopUpdate')
          ..add('name', name)
          ..add('perimeterKm', perimeterKm)
          ..add('priceEurKwh', priceEurKwh)
          ..add('commissionEurKwh', commissionEurKwh)
          ..add('allocationMode', allocationMode)
          ..add('status', status)
          ..add('enedisOperationId', enedisOperationId))
        .toString();
  }
}

class LoopUpdateBuilder implements Builder<LoopUpdate, LoopUpdateBuilder> {
  _$LoopUpdate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  num? _perimeterKm;
  num? get perimeterKm => _$this._perimeterKm;
  set perimeterKm(num? perimeterKm) => _$this._perimeterKm = perimeterKm;

  String? _priceEurKwh;
  String? get priceEurKwh => _$this._priceEurKwh;
  set priceEurKwh(String? priceEurKwh) => _$this._priceEurKwh = priceEurKwh;

  String? _commissionEurKwh;
  String? get commissionEurKwh => _$this._commissionEurKwh;
  set commissionEurKwh(String? commissionEurKwh) => _$this._commissionEurKwh = commissionEurKwh;

  AllocationMode? _allocationMode;
  AllocationMode? get allocationMode => _$this._allocationMode;
  set allocationMode(AllocationMode? allocationMode) => _$this._allocationMode = allocationMode;

  LoopStatus? _status;
  LoopStatus? get status => _$this._status;
  set status(LoopStatus? status) => _$this._status = status;

  String? _enedisOperationId;
  String? get enedisOperationId => _$this._enedisOperationId;
  set enedisOperationId(String? enedisOperationId) => _$this._enedisOperationId = enedisOperationId;

  LoopUpdateBuilder() {
    LoopUpdate._defaults(this);
  }

  LoopUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _perimeterKm = $v.perimeterKm;
      _priceEurKwh = $v.priceEurKwh;
      _commissionEurKwh = $v.commissionEurKwh;
      _allocationMode = $v.allocationMode;
      _status = $v.status;
      _enedisOperationId = $v.enedisOperationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoopUpdate other) {
    _$v = other as _$LoopUpdate;
  }

  @override
  void update(void Function(LoopUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoopUpdate build() => _build();

  _$LoopUpdate _build() {
    final _$result = _$v ??
        _$LoopUpdate._(
          name: name,
          perimeterKm: perimeterKm,
          priceEurKwh: priceEurKwh,
          commissionEurKwh: commissionEurKwh,
          allocationMode: allocationMode,
          status: status,
          enedisOperationId: enedisOperationId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
