// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_statement_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminStatementOut extends AdminStatementOut {
  @override
  final String id;
  @override
  final String? number;
  @override
  final String loopId;
  @override
  final String loopName;
  @override
  final String period;
  @override
  final MeterDirection direction;
  @override
  final StatementStatus status;
  @override
  final num kwh;
  @override
  final String priceEurKwh;
  @override
  final String commissionEurKwh;
  @override
  final String networkFeeEurKwh;
  @override
  final String grossEur;
  @override
  final String networkFeeEur;
  @override
  final String commissionEur;
  @override
  final String netEur;
  @override
  final DateTime? issuedAt;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;

  factory _$AdminStatementOut([void Function(AdminStatementOutBuilder)? updates]) =>
      (AdminStatementOutBuilder()..update(updates))._build();

  _$AdminStatementOut._(
      {required this.id,
      this.number,
      required this.loopId,
      required this.loopName,
      required this.period,
      required this.direction,
      required this.status,
      required this.kwh,
      required this.priceEurKwh,
      required this.commissionEurKwh,
      required this.networkFeeEurKwh,
      required this.grossEur,
      required this.networkFeeEur,
      required this.commissionEur,
      required this.netEur,
      this.issuedAt,
      required this.firstName,
      required this.lastName,
      required this.email})
      : super._();
  @override
  AdminStatementOut rebuild(void Function(AdminStatementOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminStatementOutBuilder toBuilder() => AdminStatementOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminStatementOut &&
        id == other.id &&
        number == other.number &&
        loopId == other.loopId &&
        loopName == other.loopName &&
        period == other.period &&
        direction == other.direction &&
        status == other.status &&
        kwh == other.kwh &&
        priceEurKwh == other.priceEurKwh &&
        commissionEurKwh == other.commissionEurKwh &&
        networkFeeEurKwh == other.networkFeeEurKwh &&
        grossEur == other.grossEur &&
        networkFeeEur == other.networkFeeEur &&
        commissionEur == other.commissionEur &&
        netEur == other.netEur &&
        issuedAt == other.issuedAt &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, loopId.hashCode);
    _$hash = $jc(_$hash, loopName.hashCode);
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, direction.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, kwh.hashCode);
    _$hash = $jc(_$hash, priceEurKwh.hashCode);
    _$hash = $jc(_$hash, commissionEurKwh.hashCode);
    _$hash = $jc(_$hash, networkFeeEurKwh.hashCode);
    _$hash = $jc(_$hash, grossEur.hashCode);
    _$hash = $jc(_$hash, networkFeeEur.hashCode);
    _$hash = $jc(_$hash, commissionEur.hashCode);
    _$hash = $jc(_$hash, netEur.hashCode);
    _$hash = $jc(_$hash, issuedAt.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminStatementOut')
          ..add('id', id)
          ..add('number', number)
          ..add('loopId', loopId)
          ..add('loopName', loopName)
          ..add('period', period)
          ..add('direction', direction)
          ..add('status', status)
          ..add('kwh', kwh)
          ..add('priceEurKwh', priceEurKwh)
          ..add('commissionEurKwh', commissionEurKwh)
          ..add('networkFeeEurKwh', networkFeeEurKwh)
          ..add('grossEur', grossEur)
          ..add('networkFeeEur', networkFeeEur)
          ..add('commissionEur', commissionEur)
          ..add('netEur', netEur)
          ..add('issuedAt', issuedAt)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('email', email))
        .toString();
  }
}

class AdminStatementOutBuilder implements Builder<AdminStatementOut, AdminStatementOutBuilder> {
  _$AdminStatementOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _loopId;
  String? get loopId => _$this._loopId;
  set loopId(String? loopId) => _$this._loopId = loopId;

  String? _loopName;
  String? get loopName => _$this._loopName;
  set loopName(String? loopName) => _$this._loopName = loopName;

  String? _period;
  String? get period => _$this._period;
  set period(String? period) => _$this._period = period;

  MeterDirection? _direction;
  MeterDirection? get direction => _$this._direction;
  set direction(MeterDirection? direction) => _$this._direction = direction;

  StatementStatus? _status;
  StatementStatus? get status => _$this._status;
  set status(StatementStatus? status) => _$this._status = status;

  num? _kwh;
  num? get kwh => _$this._kwh;
  set kwh(num? kwh) => _$this._kwh = kwh;

  String? _priceEurKwh;
  String? get priceEurKwh => _$this._priceEurKwh;
  set priceEurKwh(String? priceEurKwh) => _$this._priceEurKwh = priceEurKwh;

  String? _commissionEurKwh;
  String? get commissionEurKwh => _$this._commissionEurKwh;
  set commissionEurKwh(String? commissionEurKwh) => _$this._commissionEurKwh = commissionEurKwh;

  String? _networkFeeEurKwh;
  String? get networkFeeEurKwh => _$this._networkFeeEurKwh;
  set networkFeeEurKwh(String? networkFeeEurKwh) => _$this._networkFeeEurKwh = networkFeeEurKwh;

  String? _grossEur;
  String? get grossEur => _$this._grossEur;
  set grossEur(String? grossEur) => _$this._grossEur = grossEur;

  String? _networkFeeEur;
  String? get networkFeeEur => _$this._networkFeeEur;
  set networkFeeEur(String? networkFeeEur) => _$this._networkFeeEur = networkFeeEur;

  String? _commissionEur;
  String? get commissionEur => _$this._commissionEur;
  set commissionEur(String? commissionEur) => _$this._commissionEur = commissionEur;

  String? _netEur;
  String? get netEur => _$this._netEur;
  set netEur(String? netEur) => _$this._netEur = netEur;

  DateTime? _issuedAt;
  DateTime? get issuedAt => _$this._issuedAt;
  set issuedAt(DateTime? issuedAt) => _$this._issuedAt = issuedAt;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  AdminStatementOutBuilder() {
    AdminStatementOut._defaults(this);
  }

  AdminStatementOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _loopId = $v.loopId;
      _loopName = $v.loopName;
      _period = $v.period;
      _direction = $v.direction;
      _status = $v.status;
      _kwh = $v.kwh;
      _priceEurKwh = $v.priceEurKwh;
      _commissionEurKwh = $v.commissionEurKwh;
      _networkFeeEurKwh = $v.networkFeeEurKwh;
      _grossEur = $v.grossEur;
      _networkFeeEur = $v.networkFeeEur;
      _commissionEur = $v.commissionEur;
      _netEur = $v.netEur;
      _issuedAt = $v.issuedAt;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminStatementOut other) {
    _$v = other as _$AdminStatementOut;
  }

  @override
  void update(void Function(AdminStatementOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminStatementOut build() => _build();

  _$AdminStatementOut _build() {
    final _$result = _$v ??
        _$AdminStatementOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'AdminStatementOut', 'id'),
          number: number,
          loopId: BuiltValueNullFieldError.checkNotNull(loopId, r'AdminStatementOut', 'loopId'),
          loopName:
              BuiltValueNullFieldError.checkNotNull(loopName, r'AdminStatementOut', 'loopName'),
          period: BuiltValueNullFieldError.checkNotNull(period, r'AdminStatementOut', 'period'),
          direction:
              BuiltValueNullFieldError.checkNotNull(direction, r'AdminStatementOut', 'direction'),
          status: BuiltValueNullFieldError.checkNotNull(status, r'AdminStatementOut', 'status'),
          kwh: BuiltValueNullFieldError.checkNotNull(kwh, r'AdminStatementOut', 'kwh'),
          priceEurKwh: BuiltValueNullFieldError.checkNotNull(
              priceEurKwh, r'AdminStatementOut', 'priceEurKwh'),
          commissionEurKwh: BuiltValueNullFieldError.checkNotNull(
              commissionEurKwh, r'AdminStatementOut', 'commissionEurKwh'),
          networkFeeEurKwh: BuiltValueNullFieldError.checkNotNull(
              networkFeeEurKwh, r'AdminStatementOut', 'networkFeeEurKwh'),
          grossEur:
              BuiltValueNullFieldError.checkNotNull(grossEur, r'AdminStatementOut', 'grossEur'),
          networkFeeEur: BuiltValueNullFieldError.checkNotNull(
              networkFeeEur, r'AdminStatementOut', 'networkFeeEur'),
          commissionEur: BuiltValueNullFieldError.checkNotNull(
              commissionEur, r'AdminStatementOut', 'commissionEur'),
          netEur: BuiltValueNullFieldError.checkNotNull(netEur, r'AdminStatementOut', 'netEur'),
          issuedAt: issuedAt,
          firstName:
              BuiltValueNullFieldError.checkNotNull(firstName, r'AdminStatementOut', 'firstName'),
          lastName:
              BuiltValueNullFieldError.checkNotNull(lastName, r'AdminStatementOut', 'lastName'),
          email: BuiltValueNullFieldError.checkNotNull(email, r'AdminStatementOut', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
