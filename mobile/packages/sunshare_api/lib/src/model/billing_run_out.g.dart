// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_run_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BillingRunOut extends BillingRunOut {
  @override
  final String period;
  @override
  final BuiltList<LoopBillingOut> loops;
  @override
  final BuiltList<String> skipped;

  factory _$BillingRunOut([void Function(BillingRunOutBuilder)? updates]) =>
      (BillingRunOutBuilder()..update(updates))._build();

  _$BillingRunOut._({required this.period, required this.loops, required this.skipped}) : super._();
  @override
  BillingRunOut rebuild(void Function(BillingRunOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BillingRunOutBuilder toBuilder() => BillingRunOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BillingRunOut &&
        period == other.period &&
        loops == other.loops &&
        skipped == other.skipped;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, loops.hashCode);
    _$hash = $jc(_$hash, skipped.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BillingRunOut')
          ..add('period', period)
          ..add('loops', loops)
          ..add('skipped', skipped))
        .toString();
  }
}

class BillingRunOutBuilder implements Builder<BillingRunOut, BillingRunOutBuilder> {
  _$BillingRunOut? _$v;

  String? _period;
  String? get period => _$this._period;
  set period(String? period) => _$this._period = period;

  ListBuilder<LoopBillingOut>? _loops;
  ListBuilder<LoopBillingOut> get loops => _$this._loops ??= ListBuilder<LoopBillingOut>();
  set loops(ListBuilder<LoopBillingOut>? loops) => _$this._loops = loops;

  ListBuilder<String>? _skipped;
  ListBuilder<String> get skipped => _$this._skipped ??= ListBuilder<String>();
  set skipped(ListBuilder<String>? skipped) => _$this._skipped = skipped;

  BillingRunOutBuilder() {
    BillingRunOut._defaults(this);
  }

  BillingRunOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _period = $v.period;
      _loops = $v.loops.toBuilder();
      _skipped = $v.skipped.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BillingRunOut other) {
    _$v = other as _$BillingRunOut;
  }

  @override
  void update(void Function(BillingRunOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BillingRunOut build() => _build();

  _$BillingRunOut _build() {
    _$BillingRunOut _$result;
    try {
      _$result = _$v ??
          _$BillingRunOut._(
            period: BuiltValueNullFieldError.checkNotNull(period, r'BillingRunOut', 'period'),
            loops: loops.build(),
            skipped: skipped.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'loops';
        loops.build();
        _$failedField = 'skipped';
        skipped.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'BillingRunOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
