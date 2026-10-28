// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop_billing_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoopBillingOut extends LoopBillingOut {
  @override
  final String loopId;
  @override
  final String loopName;
  @override
  final int statements;
  @override
  final String consumersEur;
  @override
  final String payoutsEur;
  @override
  final String commissionEur;

  factory _$LoopBillingOut([void Function(LoopBillingOutBuilder)? updates]) =>
      (LoopBillingOutBuilder()..update(updates))._build();

  _$LoopBillingOut._(
      {required this.loopId,
      required this.loopName,
      required this.statements,
      required this.consumersEur,
      required this.payoutsEur,
      required this.commissionEur})
      : super._();
  @override
  LoopBillingOut rebuild(void Function(LoopBillingOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoopBillingOutBuilder toBuilder() => LoopBillingOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoopBillingOut &&
        loopId == other.loopId &&
        loopName == other.loopName &&
        statements == other.statements &&
        consumersEur == other.consumersEur &&
        payoutsEur == other.payoutsEur &&
        commissionEur == other.commissionEur;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, loopId.hashCode);
    _$hash = $jc(_$hash, loopName.hashCode);
    _$hash = $jc(_$hash, statements.hashCode);
    _$hash = $jc(_$hash, consumersEur.hashCode);
    _$hash = $jc(_$hash, payoutsEur.hashCode);
    _$hash = $jc(_$hash, commissionEur.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoopBillingOut')
          ..add('loopId', loopId)
          ..add('loopName', loopName)
          ..add('statements', statements)
          ..add('consumersEur', consumersEur)
          ..add('payoutsEur', payoutsEur)
          ..add('commissionEur', commissionEur))
        .toString();
  }
}

class LoopBillingOutBuilder implements Builder<LoopBillingOut, LoopBillingOutBuilder> {
  _$LoopBillingOut? _$v;

  String? _loopId;
  String? get loopId => _$this._loopId;
  set loopId(String? loopId) => _$this._loopId = loopId;

  String? _loopName;
  String? get loopName => _$this._loopName;
  set loopName(String? loopName) => _$this._loopName = loopName;

  int? _statements;
  int? get statements => _$this._statements;
  set statements(int? statements) => _$this._statements = statements;

  String? _consumersEur;
  String? get consumersEur => _$this._consumersEur;
  set consumersEur(String? consumersEur) => _$this._consumersEur = consumersEur;

  String? _payoutsEur;
  String? get payoutsEur => _$this._payoutsEur;
  set payoutsEur(String? payoutsEur) => _$this._payoutsEur = payoutsEur;

  String? _commissionEur;
  String? get commissionEur => _$this._commissionEur;
  set commissionEur(String? commissionEur) => _$this._commissionEur = commissionEur;

  LoopBillingOutBuilder() {
    LoopBillingOut._defaults(this);
  }

  LoopBillingOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loopId = $v.loopId;
      _loopName = $v.loopName;
      _statements = $v.statements;
      _consumersEur = $v.consumersEur;
      _payoutsEur = $v.payoutsEur;
      _commissionEur = $v.commissionEur;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoopBillingOut other) {
    _$v = other as _$LoopBillingOut;
  }

  @override
  void update(void Function(LoopBillingOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoopBillingOut build() => _build();

  _$LoopBillingOut _build() {
    final _$result = _$v ??
        _$LoopBillingOut._(
          loopId: BuiltValueNullFieldError.checkNotNull(loopId, r'LoopBillingOut', 'loopId'),
          loopName: BuiltValueNullFieldError.checkNotNull(loopName, r'LoopBillingOut', 'loopName'),
          statements:
              BuiltValueNullFieldError.checkNotNull(statements, r'LoopBillingOut', 'statements'),
          consumersEur: BuiltValueNullFieldError.checkNotNull(
              consumersEur, r'LoopBillingOut', 'consumersEur'),
          payoutsEur:
              BuiltValueNullFieldError.checkNotNull(payoutsEur, r'LoopBillingOut', 'payoutsEur'),
          commissionEur: BuiltValueNullFieldError.checkNotNull(
              commissionEur, r'LoopBillingOut', 'commissionEur'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
