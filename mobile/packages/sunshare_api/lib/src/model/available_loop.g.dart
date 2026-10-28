// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_loop.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AvailableLoop extends AvailableLoop {
  @override
  final String id;
  @override
  final String name;
  @override
  final num perimeterKm;
  @override
  final String priceEurKwh;
  @override
  final int memberCount;
  @override
  final BuiltList<String> joinableMeterIds;

  factory _$AvailableLoop([void Function(AvailableLoopBuilder)? updates]) =>
      (AvailableLoopBuilder()..update(updates))._build();

  _$AvailableLoop._(
      {required this.id,
      required this.name,
      required this.perimeterKm,
      required this.priceEurKwh,
      required this.memberCount,
      required this.joinableMeterIds})
      : super._();
  @override
  AvailableLoop rebuild(void Function(AvailableLoopBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AvailableLoopBuilder toBuilder() => AvailableLoopBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AvailableLoop &&
        id == other.id &&
        name == other.name &&
        perimeterKm == other.perimeterKm &&
        priceEurKwh == other.priceEurKwh &&
        memberCount == other.memberCount &&
        joinableMeterIds == other.joinableMeterIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, perimeterKm.hashCode);
    _$hash = $jc(_$hash, priceEurKwh.hashCode);
    _$hash = $jc(_$hash, memberCount.hashCode);
    _$hash = $jc(_$hash, joinableMeterIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AvailableLoop')
          ..add('id', id)
          ..add('name', name)
          ..add('perimeterKm', perimeterKm)
          ..add('priceEurKwh', priceEurKwh)
          ..add('memberCount', memberCount)
          ..add('joinableMeterIds', joinableMeterIds))
        .toString();
  }
}

class AvailableLoopBuilder implements Builder<AvailableLoop, AvailableLoopBuilder> {
  _$AvailableLoop? _$v;

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

  int? _memberCount;
  int? get memberCount => _$this._memberCount;
  set memberCount(int? memberCount) => _$this._memberCount = memberCount;

  ListBuilder<String>? _joinableMeterIds;
  ListBuilder<String> get joinableMeterIds => _$this._joinableMeterIds ??= ListBuilder<String>();
  set joinableMeterIds(ListBuilder<String>? joinableMeterIds) =>
      _$this._joinableMeterIds = joinableMeterIds;

  AvailableLoopBuilder() {
    AvailableLoop._defaults(this);
  }

  AvailableLoopBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _perimeterKm = $v.perimeterKm;
      _priceEurKwh = $v.priceEurKwh;
      _memberCount = $v.memberCount;
      _joinableMeterIds = $v.joinableMeterIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AvailableLoop other) {
    _$v = other as _$AvailableLoop;
  }

  @override
  void update(void Function(AvailableLoopBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AvailableLoop build() => _build();

  _$AvailableLoop _build() {
    _$AvailableLoop _$result;
    try {
      _$result = _$v ??
          _$AvailableLoop._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'AvailableLoop', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(name, r'AvailableLoop', 'name'),
            perimeterKm:
                BuiltValueNullFieldError.checkNotNull(perimeterKm, r'AvailableLoop', 'perimeterKm'),
            priceEurKwh:
                BuiltValueNullFieldError.checkNotNull(priceEurKwh, r'AvailableLoop', 'priceEurKwh'),
            memberCount:
                BuiltValueNullFieldError.checkNotNull(memberCount, r'AvailableLoop', 'memberCount'),
            joinableMeterIds: joinableMeterIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'joinableMeterIds';
        joinableMeterIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'AvailableLoop', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
