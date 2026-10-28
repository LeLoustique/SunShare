// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoopCreate extends LoopCreate {
  @override
  final String name;
  @override
  final num? perimeterKm;
  @override
  final String priceEurKwh;
  @override
  final String commissionEurKwh;
  @override
  final AllocationMode? allocationMode;
  @override
  final String? enedisOperationId;

  factory _$LoopCreate([void Function(LoopCreateBuilder)? updates]) =>
      (LoopCreateBuilder()..update(updates))._build();

  _$LoopCreate._(
      {required this.name,
      this.perimeterKm,
      required this.priceEurKwh,
      required this.commissionEurKwh,
      this.allocationMode,
      this.enedisOperationId})
      : super._();
  @override
  LoopCreate rebuild(void Function(LoopCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoopCreateBuilder toBuilder() => LoopCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoopCreate &&
        name == other.name &&
        perimeterKm == other.perimeterKm &&
        priceEurKwh == other.priceEurKwh &&
        commissionEurKwh == other.commissionEurKwh &&
        allocationMode == other.allocationMode &&
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
    _$hash = $jc(_$hash, enedisOperationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoopCreate')
          ..add('name', name)
          ..add('perimeterKm', perimeterKm)
          ..add('priceEurKwh', priceEurKwh)
          ..add('commissionEurKwh', commissionEurKwh)
          ..add('allocationMode', allocationMode)
          ..add('enedisOperationId', enedisOperationId))
        .toString();
  }
}

class LoopCreateBuilder implements Builder<LoopCreate, LoopCreateBuilder> {
  _$LoopCreate? _$v;

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

  String? _enedisOperationId;
  String? get enedisOperationId => _$this._enedisOperationId;
  set enedisOperationId(String? enedisOperationId) => _$this._enedisOperationId = enedisOperationId;

  LoopCreateBuilder() {
    LoopCreate._defaults(this);
  }

  LoopCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _perimeterKm = $v.perimeterKm;
      _priceEurKwh = $v.priceEurKwh;
      _commissionEurKwh = $v.commissionEurKwh;
      _allocationMode = $v.allocationMode;
      _enedisOperationId = $v.enedisOperationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoopCreate other) {
    _$v = other as _$LoopCreate;
  }

  @override
  void update(void Function(LoopCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoopCreate build() => _build();

  _$LoopCreate _build() {
    final _$result = _$v ??
        _$LoopCreate._(
          name: BuiltValueNullFieldError.checkNotNull(name, r'LoopCreate', 'name'),
          perimeterKm: perimeterKm,
          priceEurKwh:
              BuiltValueNullFieldError.checkNotNull(priceEurKwh, r'LoopCreate', 'priceEurKwh'),
          commissionEurKwh: BuiltValueNullFieldError.checkNotNull(
              commissionEurKwh, r'LoopCreate', 'commissionEurKwh'),
          allocationMode: allocationMode,
          enedisOperationId: enedisOperationId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
