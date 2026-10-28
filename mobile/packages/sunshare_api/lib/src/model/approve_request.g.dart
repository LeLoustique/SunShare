// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approve_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApproveRequest extends ApproveRequest {
  @override
  final Date joinedAt;

  factory _$ApproveRequest([void Function(ApproveRequestBuilder)? updates]) =>
      (ApproveRequestBuilder()..update(updates))._build();

  _$ApproveRequest._({required this.joinedAt}) : super._();
  @override
  ApproveRequest rebuild(void Function(ApproveRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApproveRequestBuilder toBuilder() => ApproveRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApproveRequest && joinedAt == other.joinedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, joinedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApproveRequest')..add('joinedAt', joinedAt)).toString();
  }
}

class ApproveRequestBuilder implements Builder<ApproveRequest, ApproveRequestBuilder> {
  _$ApproveRequest? _$v;

  Date? _joinedAt;
  Date? get joinedAt => _$this._joinedAt;
  set joinedAt(Date? joinedAt) => _$this._joinedAt = joinedAt;

  ApproveRequestBuilder() {
    ApproveRequest._defaults(this);
  }

  ApproveRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _joinedAt = $v.joinedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApproveRequest other) {
    _$v = other as _$ApproveRequest;
  }

  @override
  void update(void Function(ApproveRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApproveRequest build() => _build();

  _$ApproveRequest _build() {
    final _$result = _$v ??
        _$ApproveRequest._(
          joinedAt: BuiltValueNullFieldError.checkNotNull(joinedAt, r'ApproveRequest', 'joinedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
