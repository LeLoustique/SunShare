// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_loop_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminLoopOut extends AdminLoopOut {
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
  @override
  final String commissionEurKwh;
  @override
  final AllocationMode allocationMode;
  @override
  final String? enedisOperationId;
  @override
  final int pendingCount;
  @override
  final DateTime createdAt;

  factory _$AdminLoopOut([void Function(AdminLoopOutBuilder)? updates]) =>
      (AdminLoopOutBuilder()..update(updates))._build();

  _$AdminLoopOut._(
      {required this.id,
      required this.name,
      required this.perimeterKm,
      required this.priceEurKwh,
      required this.status,
      required this.stats,
      required this.commissionEurKwh,
      required this.allocationMode,
      this.enedisOperationId,
      required this.pendingCount,
      required this.createdAt})
      : super._();
  @override
  AdminLoopOut rebuild(void Function(AdminLoopOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminLoopOutBuilder toBuilder() => AdminLoopOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLoopOut &&
        id == other.id &&
        name == other.name &&
        perimeterKm == other.perimeterKm &&
        priceEurKwh == other.priceEurKwh &&
        status == other.status &&
        stats == other.stats &&
        commissionEurKwh == other.commissionEurKwh &&
        allocationMode == other.allocationMode &&
        enedisOperationId == other.enedisOperationId &&
        pendingCount == other.pendingCount &&
        createdAt == other.createdAt;
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
    _$hash = $jc(_$hash, commissionEurKwh.hashCode);
    _$hash = $jc(_$hash, allocationMode.hashCode);
    _$hash = $jc(_$hash, enedisOperationId.hashCode);
    _$hash = $jc(_$hash, pendingCount.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminLoopOut')
          ..add('id', id)
          ..add('name', name)
          ..add('perimeterKm', perimeterKm)
          ..add('priceEurKwh', priceEurKwh)
          ..add('status', status)
          ..add('stats', stats)
          ..add('commissionEurKwh', commissionEurKwh)
          ..add('allocationMode', allocationMode)
          ..add('enedisOperationId', enedisOperationId)
          ..add('pendingCount', pendingCount)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AdminLoopOutBuilder implements Builder<AdminLoopOut, AdminLoopOutBuilder> {
  _$AdminLoopOut? _$v;

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

  String? _commissionEurKwh;
  String? get commissionEurKwh => _$this._commissionEurKwh;
  set commissionEurKwh(String? commissionEurKwh) => _$this._commissionEurKwh = commissionEurKwh;

  AllocationMode? _allocationMode;
  AllocationMode? get allocationMode => _$this._allocationMode;
  set allocationMode(AllocationMode? allocationMode) => _$this._allocationMode = allocationMode;

  String? _enedisOperationId;
  String? get enedisOperationId => _$this._enedisOperationId;
  set enedisOperationId(String? enedisOperationId) => _$this._enedisOperationId = enedisOperationId;

  int? _pendingCount;
  int? get pendingCount => _$this._pendingCount;
  set pendingCount(int? pendingCount) => _$this._pendingCount = pendingCount;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminLoopOutBuilder() {
    AdminLoopOut._defaults(this);
  }

  AdminLoopOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _perimeterKm = $v.perimeterKm;
      _priceEurKwh = $v.priceEurKwh;
      _status = $v.status;
      _stats = $v.stats.toBuilder();
      _commissionEurKwh = $v.commissionEurKwh;
      _allocationMode = $v.allocationMode;
      _enedisOperationId = $v.enedisOperationId;
      _pendingCount = $v.pendingCount;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminLoopOut other) {
    _$v = other as _$AdminLoopOut;
  }

  @override
  void update(void Function(AdminLoopOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminLoopOut build() => _build();

  _$AdminLoopOut _build() {
    _$AdminLoopOut _$result;
    try {
      _$result = _$v ??
          _$AdminLoopOut._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'AdminLoopOut', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(name, r'AdminLoopOut', 'name'),
            perimeterKm:
                BuiltValueNullFieldError.checkNotNull(perimeterKm, r'AdminLoopOut', 'perimeterKm'),
            priceEurKwh:
                BuiltValueNullFieldError.checkNotNull(priceEurKwh, r'AdminLoopOut', 'priceEurKwh'),
            status: BuiltValueNullFieldError.checkNotNull(status, r'AdminLoopOut', 'status'),
            stats: stats.build(),
            commissionEurKwh: BuiltValueNullFieldError.checkNotNull(
                commissionEurKwh, r'AdminLoopOut', 'commissionEurKwh'),
            allocationMode: BuiltValueNullFieldError.checkNotNull(
                allocationMode, r'AdminLoopOut', 'allocationMode'),
            enedisOperationId: enedisOperationId,
            pendingCount: BuiltValueNullFieldError.checkNotNull(
                pendingCount, r'AdminLoopOut', 'pendingCount'),
            createdAt:
                BuiltValueNullFieldError.checkNotNull(createdAt, r'AdminLoopOut', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stats';
        stats.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'AdminLoopOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
