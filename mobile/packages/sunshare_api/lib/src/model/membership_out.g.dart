// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MembershipOut extends MembershipOut {
  @override
  final String id;
  @override
  final String loopId;
  @override
  final String loopName;
  @override
  final String meterId;
  @override
  final String prm;
  @override
  final MeterDirection direction;
  @override
  final MembershipStatus status;
  @override
  final DateTime requestedAt;
  @override
  final Date? joinedAt;
  @override
  final Date? leftAt;

  factory _$MembershipOut([void Function(MembershipOutBuilder)? updates]) =>
      (MembershipOutBuilder()..update(updates))._build();

  _$MembershipOut._(
      {required this.id,
      required this.loopId,
      required this.loopName,
      required this.meterId,
      required this.prm,
      required this.direction,
      required this.status,
      required this.requestedAt,
      this.joinedAt,
      this.leftAt})
      : super._();
  @override
  MembershipOut rebuild(void Function(MembershipOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipOutBuilder toBuilder() => MembershipOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipOut &&
        id == other.id &&
        loopId == other.loopId &&
        loopName == other.loopName &&
        meterId == other.meterId &&
        prm == other.prm &&
        direction == other.direction &&
        status == other.status &&
        requestedAt == other.requestedAt &&
        joinedAt == other.joinedAt &&
        leftAt == other.leftAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, loopId.hashCode);
    _$hash = $jc(_$hash, loopName.hashCode);
    _$hash = $jc(_$hash, meterId.hashCode);
    _$hash = $jc(_$hash, prm.hashCode);
    _$hash = $jc(_$hash, direction.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, joinedAt.hashCode);
    _$hash = $jc(_$hash, leftAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MembershipOut')
          ..add('id', id)
          ..add('loopId', loopId)
          ..add('loopName', loopName)
          ..add('meterId', meterId)
          ..add('prm', prm)
          ..add('direction', direction)
          ..add('status', status)
          ..add('requestedAt', requestedAt)
          ..add('joinedAt', joinedAt)
          ..add('leftAt', leftAt))
        .toString();
  }
}

class MembershipOutBuilder implements Builder<MembershipOut, MembershipOutBuilder> {
  _$MembershipOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _loopId;
  String? get loopId => _$this._loopId;
  set loopId(String? loopId) => _$this._loopId = loopId;

  String? _loopName;
  String? get loopName => _$this._loopName;
  set loopName(String? loopName) => _$this._loopName = loopName;

  String? _meterId;
  String? get meterId => _$this._meterId;
  set meterId(String? meterId) => _$this._meterId = meterId;

  String? _prm;
  String? get prm => _$this._prm;
  set prm(String? prm) => _$this._prm = prm;

  MeterDirection? _direction;
  MeterDirection? get direction => _$this._direction;
  set direction(MeterDirection? direction) => _$this._direction = direction;

  MembershipStatus? _status;
  MembershipStatus? get status => _$this._status;
  set status(MembershipStatus? status) => _$this._status = status;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  Date? _joinedAt;
  Date? get joinedAt => _$this._joinedAt;
  set joinedAt(Date? joinedAt) => _$this._joinedAt = joinedAt;

  Date? _leftAt;
  Date? get leftAt => _$this._leftAt;
  set leftAt(Date? leftAt) => _$this._leftAt = leftAt;

  MembershipOutBuilder() {
    MembershipOut._defaults(this);
  }

  MembershipOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _loopId = $v.loopId;
      _loopName = $v.loopName;
      _meterId = $v.meterId;
      _prm = $v.prm;
      _direction = $v.direction;
      _status = $v.status;
      _requestedAt = $v.requestedAt;
      _joinedAt = $v.joinedAt;
      _leftAt = $v.leftAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipOut other) {
    _$v = other as _$MembershipOut;
  }

  @override
  void update(void Function(MembershipOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipOut build() => _build();

  _$MembershipOut _build() {
    final _$result = _$v ??
        _$MembershipOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'MembershipOut', 'id'),
          loopId: BuiltValueNullFieldError.checkNotNull(loopId, r'MembershipOut', 'loopId'),
          loopName: BuiltValueNullFieldError.checkNotNull(loopName, r'MembershipOut', 'loopName'),
          meterId: BuiltValueNullFieldError.checkNotNull(meterId, r'MembershipOut', 'meterId'),
          prm: BuiltValueNullFieldError.checkNotNull(prm, r'MembershipOut', 'prm'),
          direction:
              BuiltValueNullFieldError.checkNotNull(direction, r'MembershipOut', 'direction'),
          status: BuiltValueNullFieldError.checkNotNull(status, r'MembershipOut', 'status'),
          requestedAt:
              BuiltValueNullFieldError.checkNotNull(requestedAt, r'MembershipOut', 'requestedAt'),
          joinedAt: joinedAt,
          leftAt: leftAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
