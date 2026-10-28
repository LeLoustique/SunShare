// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop_stats.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoopStats extends LoopStats {
  @override
  final int memberCount;
  @override
  final int producerCount;
  @override
  final int consumerCount;
  @override
  final num totalPeakKw;
  @override
  final num diameterKm;

  factory _$LoopStats([void Function(LoopStatsBuilder)? updates]) =>
      (LoopStatsBuilder()..update(updates))._build();

  _$LoopStats._(
      {required this.memberCount,
      required this.producerCount,
      required this.consumerCount,
      required this.totalPeakKw,
      required this.diameterKm})
      : super._();
  @override
  LoopStats rebuild(void Function(LoopStatsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoopStatsBuilder toBuilder() => LoopStatsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoopStats &&
        memberCount == other.memberCount &&
        producerCount == other.producerCount &&
        consumerCount == other.consumerCount &&
        totalPeakKw == other.totalPeakKw &&
        diameterKm == other.diameterKm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, memberCount.hashCode);
    _$hash = $jc(_$hash, producerCount.hashCode);
    _$hash = $jc(_$hash, consumerCount.hashCode);
    _$hash = $jc(_$hash, totalPeakKw.hashCode);
    _$hash = $jc(_$hash, diameterKm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoopStats')
          ..add('memberCount', memberCount)
          ..add('producerCount', producerCount)
          ..add('consumerCount', consumerCount)
          ..add('totalPeakKw', totalPeakKw)
          ..add('diameterKm', diameterKm))
        .toString();
  }
}

class LoopStatsBuilder implements Builder<LoopStats, LoopStatsBuilder> {
  _$LoopStats? _$v;

  int? _memberCount;
  int? get memberCount => _$this._memberCount;
  set memberCount(int? memberCount) => _$this._memberCount = memberCount;

  int? _producerCount;
  int? get producerCount => _$this._producerCount;
  set producerCount(int? producerCount) => _$this._producerCount = producerCount;

  int? _consumerCount;
  int? get consumerCount => _$this._consumerCount;
  set consumerCount(int? consumerCount) => _$this._consumerCount = consumerCount;

  num? _totalPeakKw;
  num? get totalPeakKw => _$this._totalPeakKw;
  set totalPeakKw(num? totalPeakKw) => _$this._totalPeakKw = totalPeakKw;

  num? _diameterKm;
  num? get diameterKm => _$this._diameterKm;
  set diameterKm(num? diameterKm) => _$this._diameterKm = diameterKm;

  LoopStatsBuilder() {
    LoopStats._defaults(this);
  }

  LoopStatsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _memberCount = $v.memberCount;
      _producerCount = $v.producerCount;
      _consumerCount = $v.consumerCount;
      _totalPeakKw = $v.totalPeakKw;
      _diameterKm = $v.diameterKm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoopStats other) {
    _$v = other as _$LoopStats;
  }

  @override
  void update(void Function(LoopStatsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoopStats build() => _build();

  _$LoopStats _build() {
    final _$result = _$v ??
        _$LoopStats._(
          memberCount:
              BuiltValueNullFieldError.checkNotNull(memberCount, r'LoopStats', 'memberCount'),
          producerCount:
              BuiltValueNullFieldError.checkNotNull(producerCount, r'LoopStats', 'producerCount'),
          consumerCount:
              BuiltValueNullFieldError.checkNotNull(consumerCount, r'LoopStats', 'consumerCount'),
          totalPeakKw:
              BuiltValueNullFieldError.checkNotNull(totalPeakKw, r'LoopStats', 'totalPeakKw'),
          diameterKm: BuiltValueNullFieldError.checkNotNull(diameterKm, r'LoopStats', 'diameterKm'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
