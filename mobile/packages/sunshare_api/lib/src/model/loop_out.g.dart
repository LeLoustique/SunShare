// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoopOut extends LoopOut {
  @override
  final String id;
  @override
  final String name;
  @override
  final num perimeterKm;
  @override
  final String priceEurKwh;
  @override
  final LoopStatus status;
  @override
  final LoopStats stats;

  factory _$LoopOut([void Function(LoopOutBuilder)? updates]) =>
      (LoopOutBuilder()..update(updates))._build();

  _$LoopOut._(
      {required this.id,
      required this.name,
      required this.perimeterKm,
      required this.priceEurKwh,
      required this.status,
      required this.stats})
      : super._();
  @override
  LoopOut rebuild(void Function(LoopOutBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  LoopOutBuilder toBuilder() => LoopOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoopOut &&
        id == other.id &&
        name == other.name &&
        perimeterKm == other.perimeterKm &&
        priceEurKwh == other.priceEurKwh &&
        status == other.status &&
        stats == other.stats;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, perimeterKm.hashCode);
    _$hash = $jc(_$hash, priceEurKwh.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, stats.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoopOut')
          ..add('id', id)
          ..add('name', name)
          ..add('perimeterKm', perimeterKm)
          ..add('priceEurKwh', priceEurKwh)
          ..add('status', status)
          ..add('stats', stats))
        .toString();
  }
}

class LoopOutBuilder implements Builder<LoopOut, LoopOutBuilder> {
  _$LoopOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  num? _perimeterKm;
  num? get perimeterKm => _$this._perimeterKm;
  set perimeterKm(num? perimeterKm) => _$this._perimeterKm = perimeterKm;

  String? _priceEurKwh;
  String? get priceEurKwh => _$this._priceEurKwh;
  set priceEurKwh(String? priceEurKwh) => _$this._priceEurKwh = priceEurKwh;

  LoopStatus? _status;
  LoopStatus? get status => _$this._status;
  set status(LoopStatus? status) => _$this._status = status;

  LoopStatsBuilder? _stats;
  LoopStatsBuilder get stats => _$this._stats ??= LoopStatsBuilder();
  set stats(LoopStatsBuilder? stats) => _$this._stats = stats;

  LoopOutBuilder() {
    LoopOut._defaults(this);
  }

  LoopOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _perimeterKm = $v.perimeterKm;
      _priceEurKwh = $v.priceEurKwh;
      _status = $v.status;
      _stats = $v.stats.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoopOut other) {
    _$v = other as _$LoopOut;
  }

  @override
  void update(void Function(LoopOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoopOut build() => _build();

  _$LoopOut _build() {
    _$LoopOut _$result;
    try {
      _$result = _$v ??
          _$LoopOut._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'LoopOut', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(name, r'LoopOut', 'name'),
            perimeterKm:
                BuiltValueNullFieldError.checkNotNull(perimeterKm, r'LoopOut', 'perimeterKm'),
            priceEurKwh:
                BuiltValueNullFieldError.checkNotNull(priceEurKwh, r'LoopOut', 'priceEurKwh'),
            status: BuiltValueNullFieldError.checkNotNull(status, r'LoopOut', 'status'),
            stats: stats.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stats';
        stats.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'LoopOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
