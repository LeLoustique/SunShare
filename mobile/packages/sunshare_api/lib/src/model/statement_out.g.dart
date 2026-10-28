// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StatementOut extends StatementOut {
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

  factory _$StatementOut([void Function(StatementOutBuilder)? updates]) =>
      (StatementOutBuilder()..update(updates))._build();

  _$StatementOut._(
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
      this.issuedAt})
      : super._();
  @override
  StatementOut rebuild(void Function(StatementOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatementOutBuilder toBuilder() => StatementOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatementOut &&
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
        issuedAt == other.issuedAt;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatementOut')
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
          ..add('issuedAt', issuedAt))
        .toString();
  }
}

class StatementOutBuilder implements Builder<StatementOut, StatementOutBuilder> {
  _$StatementOut? _$v;

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

  StatementOutBuilder() {
    StatementOut._defaults(this);
  }

  StatementOutBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatementOut other) {
    _$v = other as _$StatementOut;
  }

  @override
  void update(void Function(StatementOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatementOut build() => _build();

  _$StatementOut _build() {
    final _$result = _$v ??
        _$StatementOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'StatementOut', 'id'),
          number: number,
          loopId: BuiltValueNullFieldError.checkNotNull(loopId, r'StatementOut', 'loopId'),
          loopName: BuiltValueNullFieldError.checkNotNull(loopName, r'StatementOut', 'loopName'),
          period: BuiltValueNullFieldError.checkNotNull(period, r'StatementOut', 'period'),
          direction: BuiltValueNullFieldError.checkNotNull(direction, r'StatementOut', 'direction'),
          status: BuiltValueNullFieldError.checkNotNull(status, r'StatementOut', 'status'),
          kwh: BuiltValueNullFieldError.checkNotNull(kwh, r'StatementOut', 'kwh'),
          priceEurKwh:
              BuiltValueNullFieldError.checkNotNull(priceEurKwh, r'StatementOut', 'priceEurKwh'),
          commissionEurKwh: BuiltValueNullFieldError.checkNotNull(
              commissionEurKwh, r'StatementOut', 'commissionEurKwh'),
          networkFeeEurKwh: BuiltValueNullFieldError.checkNotNull(
              networkFeeEurKwh, r'StatementOut', 'networkFeeEurKwh'),
          grossEur: BuiltValueNullFieldError.checkNotNull(grossEur, r'StatementOut', 'grossEur'),
          networkFeeEur: BuiltValueNullFieldError.checkNotNull(
              networkFeeEur, r'StatementOut', 'networkFeeEur'),
          commissionEur: BuiltValueNullFieldError.checkNotNull(
              commissionEur, r'StatementOut', 'commissionEur'),
          netEur: BuiltValueNullFieldError.checkNotNull(netEur, r'StatementOut', 'netEur'),
          issuedAt: issuedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
