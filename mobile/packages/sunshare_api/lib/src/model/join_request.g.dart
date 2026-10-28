// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$JoinRequest extends JoinRequest {
  @override
  final String meterId;

  factory _$JoinRequest([void Function(JoinRequestBuilder)? updates]) =>
      (JoinRequestBuilder()..update(updates))._build();

  _$JoinRequest._({required this.meterId}) : super._();
  @override
  JoinRequest rebuild(void Function(JoinRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JoinRequestBuilder toBuilder() => JoinRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JoinRequest && meterId == other.meterId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meterId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JoinRequest')..add('meterId', meterId)).toString();
  }
}

class JoinRequestBuilder implements Builder<JoinRequest, JoinRequestBuilder> {
  _$JoinRequest? _$v;

  String? _meterId;
  String? get meterId => _$this._meterId;
  set meterId(String? meterId) => _$this._meterId = meterId;

  JoinRequestBuilder() {
    JoinRequest._defaults(this);
  }

  JoinRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meterId = $v.meterId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JoinRequest other) {
    _$v = other as _$JoinRequest;
  }

  @override
  void update(void Function(JoinRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JoinRequest build() => _build();

  _$JoinRequest _build() {
    final _$result = _$v ??
        _$JoinRequest._(
          meterId: BuiltValueNullFieldError.checkNotNull(meterId, r'JoinRequest', 'meterId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
