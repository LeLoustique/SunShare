// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MeterCreate extends MeterCreate {
  @override
  final String prm;
  @override
  final MeterDirection direction;
  @override
  final String address;
  @override
  final num? peakKw;

  factory _$MeterCreate([void Function(MeterCreateBuilder)? updates]) =>
      (MeterCreateBuilder()..update(updates))._build();

  _$MeterCreate._({required this.prm, required this.direction, required this.address, this.peakKw})
      : super._();
  @override
  MeterCreate rebuild(void Function(MeterCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeterCreateBuilder toBuilder() => MeterCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MeterCreate &&
        prm == other.prm &&
        direction == other.direction &&
        address == other.address &&
        peakKw == other.peakKw;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, prm.hashCode);
    _$hash = $jc(_$hash, direction.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, peakKw.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MeterCreate')
          ..add('prm', prm)
          ..add('direction', direction)
          ..add('address', address)
          ..add('peakKw', peakKw))
        .toString();
  }
}

class MeterCreateBuilder implements Builder<MeterCreate, MeterCreateBuilder> {
  _$MeterCreate? _$v;

  String? _prm;
  String? get prm => _$this._prm;
  set prm(String? prm) => _$this._prm = prm;

  MeterDirection? _direction;
  MeterDirection? get direction => _$this._direction;
  set direction(MeterDirection? direction) => _$this._direction = direction;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  num? _peakKw;
  num? get peakKw => _$this._peakKw;
  set peakKw(num? peakKw) => _$this._peakKw = peakKw;

  MeterCreateBuilder() {
    MeterCreate._defaults(this);
  }

  MeterCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _prm = $v.prm;
      _direction = $v.direction;
      _address = $v.address;
      _peakKw = $v.peakKw;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MeterCreate other) {
    _$v = other as _$MeterCreate;
  }

  @override
  void update(void Function(MeterCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MeterCreate build() => _build();

  _$MeterCreate _build() {
    final _$result = _$v ??
        _$MeterCreate._(
          prm: BuiltValueNullFieldError.checkNotNull(prm, r'MeterCreate', 'prm'),
          direction: BuiltValueNullFieldError.checkNotNull(direction, r'MeterCreate', 'direction'),
          address: BuiltValueNullFieldError.checkNotNull(address, r'MeterCreate', 'address'),
          peakKw: peakKw,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
