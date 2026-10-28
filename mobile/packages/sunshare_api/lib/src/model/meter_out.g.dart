// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MeterOut extends MeterOut {
  @override
  final String id;
  @override
  final String prm;
  @override
  final MeterDirection direction;
  @override
  final String address;
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final num? peakKw;
  @override
  final DateTime createdAt;

  factory _$MeterOut([void Function(MeterOutBuilder)? updates]) =>
      (MeterOutBuilder()..update(updates))._build();

  _$MeterOut._(
      {required this.id,
      required this.prm,
      required this.direction,
      required this.address,
      required this.latitude,
      required this.longitude,
      this.peakKw,
      required this.createdAt})
      : super._();
  @override
  MeterOut rebuild(void Function(MeterOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeterOutBuilder toBuilder() => MeterOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MeterOut &&
        id == other.id &&
        prm == other.prm &&
        direction == other.direction &&
        address == other.address &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        peakKw == other.peakKw &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, prm.hashCode);
    _$hash = $jc(_$hash, direction.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, peakKw.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MeterOut')
          ..add('id', id)
          ..add('prm', prm)
          ..add('direction', direction)
          ..add('address', address)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('peakKw', peakKw)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class MeterOutBuilder implements Builder<MeterOut, MeterOutBuilder> {
  _$MeterOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _prm;
  String? get prm => _$this._prm;
  set prm(String? prm) => _$this._prm = prm;

  MeterDirection? _direction;
  MeterDirection? get direction => _$this._direction;
  set direction(MeterDirection? direction) => _$this._direction = direction;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  num? _peakKw;
  num? get peakKw => _$this._peakKw;
  set peakKw(num? peakKw) => _$this._peakKw = peakKw;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MeterOutBuilder() {
    MeterOut._defaults(this);
  }

  MeterOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _prm = $v.prm;
      _direction = $v.direction;
      _address = $v.address;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _peakKw = $v.peakKw;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MeterOut other) {
    _$v = other as _$MeterOut;
  }

  @override
  void update(void Function(MeterOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MeterOut build() => _build();

  _$MeterOut _build() {
    final _$result = _$v ??
        _$MeterOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'MeterOut', 'id'),
          prm: BuiltValueNullFieldError.checkNotNull(prm, r'MeterOut', 'prm'),
          direction: BuiltValueNullFieldError.checkNotNull(direction, r'MeterOut', 'direction'),
          address: BuiltValueNullFieldError.checkNotNull(address, r'MeterOut', 'address'),
          latitude: BuiltValueNullFieldError.checkNotNull(latitude, r'MeterOut', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(longitude, r'MeterOut', 'longitude'),
          peakKw: peakKw,
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt, r'MeterOut', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
