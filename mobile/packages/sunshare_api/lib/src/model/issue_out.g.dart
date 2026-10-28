// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IssueOut extends IssueOut {
  @override
  final String period;
  @override
  final int issued;
  @override
  final String firstNumber;
  @override
  final String lastNumber;

  factory _$IssueOut([void Function(IssueOutBuilder)? updates]) =>
      (IssueOutBuilder()..update(updates))._build();

  _$IssueOut._(
      {required this.period,
      required this.issued,
      required this.firstNumber,
      required this.lastNumber})
      : super._();
  @override
  IssueOut rebuild(void Function(IssueOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IssueOutBuilder toBuilder() => IssueOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IssueOut &&
        period == other.period &&
        issued == other.issued &&
        firstNumber == other.firstNumber &&
        lastNumber == other.lastNumber;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, issued.hashCode);
    _$hash = $jc(_$hash, firstNumber.hashCode);
    _$hash = $jc(_$hash, lastNumber.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IssueOut')
          ..add('period', period)
          ..add('issued', issued)
          ..add('firstNumber', firstNumber)
          ..add('lastNumber', lastNumber))
        .toString();
  }
}

class IssueOutBuilder implements Builder<IssueOut, IssueOutBuilder> {
  _$IssueOut? _$v;

  String? _period;
  String? get period => _$this._period;
  set period(String? period) => _$this._period = period;

  int? _issued;
  int? get issued => _$this._issued;
  set issued(int? issued) => _$this._issued = issued;

  String? _firstNumber;
  String? get firstNumber => _$this._firstNumber;
  set firstNumber(String? firstNumber) => _$this._firstNumber = firstNumber;

  String? _lastNumber;
  String? get lastNumber => _$this._lastNumber;
  set lastNumber(String? lastNumber) => _$this._lastNumber = lastNumber;

  IssueOutBuilder() {
    IssueOut._defaults(this);
  }

  IssueOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _period = $v.period;
      _issued = $v.issued;
      _firstNumber = $v.firstNumber;
      _lastNumber = $v.lastNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IssueOut other) {
    _$v = other as _$IssueOut;
  }

  @override
  void update(void Function(IssueOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IssueOut build() => _build();

  _$IssueOut _build() {
    final _$result = _$v ??
        _$IssueOut._(
          period: BuiltValueNullFieldError.checkNotNull(period, r'IssueOut', 'period'),
          issued: BuiltValueNullFieldError.checkNotNull(issued, r'IssueOut', 'issued'),
          firstNumber:
              BuiltValueNullFieldError.checkNotNull(firstNumber, r'IssueOut', 'firstNumber'),
          lastNumber: BuiltValueNullFieldError.checkNotNull(lastNumber, r'IssueOut', 'lastNumber'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
