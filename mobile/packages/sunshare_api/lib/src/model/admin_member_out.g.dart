// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_member_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMemberOut extends AdminMemberOut {
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
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;
  @override
  final String address;
  @override
  final num? peakKw;

  factory _$AdminMemberOut([void Function(AdminMemberOutBuilder)? updates]) =>
      (AdminMemberOutBuilder()..update(updates))._build();

  _$AdminMemberOut._(
      {required this.id,
      required this.loopId,
      required this.loopName,
      required this.meterId,
      required this.prm,
      required this.direction,
      required this.status,
      required this.requestedAt,
      this.joinedAt,
      this.leftAt,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.address,
      this.peakKw})
      : super._();
  @override
  AdminMemberOut rebuild(void Function(AdminMemberOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminMemberOutBuilder toBuilder() => AdminMemberOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMemberOut &&
        id == other.id &&
        loopId == other.loopId &&
        loopName == other.loopName &&
        meterId == other.meterId &&
        prm == other.prm &&
        direction == other.direction &&
        status == other.status &&
        requestedAt == other.requestedAt &&
        joinedAt == other.joinedAt &&
        leftAt == other.leftAt &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        email == other.email &&
        address == other.address &&
        peakKw == other.peakKw;
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
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, peakKw.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMemberOut')
          ..add('id', id)
          ..add('loopId', loopId)
          ..add('loopName', loopName)
          ..add('meterId', meterId)
          ..add('prm', prm)
          ..add('direction', direction)
          ..add('status', status)
          ..add('requestedAt', requestedAt)
          ..add('joinedAt', joinedAt)
          ..add('leftAt', leftAt)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('email', email)
          ..add('address', address)
          ..add('peakKw', peakKw))
        .toString();
  }
}

class AdminMemberOutBuilder implements Builder<AdminMemberOut, AdminMemberOutBuilder> {
  _$AdminMemberOut? _$v;

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

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  num? _peakKw;
  num? get peakKw => _$this._peakKw;
  set peakKw(num? peakKw) => _$this._peakKw = peakKw;

  AdminMemberOutBuilder() {
    AdminMemberOut._defaults(this);
  }

  AdminMemberOutBuilder get _$this {
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
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _email = $v.email;
      _address = $v.address;
      _peakKw = $v.peakKw;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMemberOut other) {
    _$v = other as _$AdminMemberOut;
  }

  @override
  void update(void Function(AdminMemberOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMemberOut build() => _build();

  _$AdminMemberOut _build() {
    final _$result = _$v ??
        _$AdminMemberOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'AdminMemberOut', 'id'),
          loopId: BuiltValueNullFieldError.checkNotNull(loopId, r'AdminMemberOut', 'loopId'),
          loopName: BuiltValueNullFieldError.checkNotNull(loopName, r'AdminMemberOut', 'loopName'),
          meterId: BuiltValueNullFieldError.checkNotNull(meterId, r'AdminMemberOut', 'meterId'),
          prm: BuiltValueNullFieldError.checkNotNull(prm, r'AdminMemberOut', 'prm'),
          direction:
              BuiltValueNullFieldError.checkNotNull(direction, r'AdminMemberOut', 'direction'),
          status: BuiltValueNullFieldError.checkNotNull(status, r'AdminMemberOut', 'status'),
          requestedAt:
              BuiltValueNullFieldError.checkNotNull(requestedAt, r'AdminMemberOut', 'requestedAt'),
          joinedAt: joinedAt,
          leftAt: leftAt,
          firstName:
              BuiltValueNullFieldError.checkNotNull(firstName, r'AdminMemberOut', 'firstName'),
          lastName: BuiltValueNullFieldError.checkNotNull(lastName, r'AdminMemberOut', 'lastName'),
          email: BuiltValueNullFieldError.checkNotNull(email, r'AdminMemberOut', 'email'),
          address: BuiltValueNullFieldError.checkNotNull(address, r'AdminMemberOut', 'address'),
          peakKw: peakKw,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
