// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HealthOut extends HealthOut {
  @override
  final String status;
  @override
  final BuiltMap<String, String> extensions;

  factory _$HealthOut([void Function(HealthOutBuilder)? updates]) =>
      (HealthOutBuilder()..update(updates))._build();

  _$HealthOut._({required this.status, required this.extensions}) : super._();
  @override
  HealthOut rebuild(void Function(HealthOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HealthOutBuilder toBuilder() => HealthOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthOut && status == other.status && extensions == other.extensions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, extensions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HealthOut')
          ..add('status', status)
          ..add('extensions', extensions))
        .toString();
  }
}

class HealthOutBuilder implements Builder<HealthOut, HealthOutBuilder> {
  _$HealthOut? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  MapBuilder<String, String>? _extensions;
  MapBuilder<String, String> get extensions => _$this._extensions ??= MapBuilder<String, String>();
  set extensions(MapBuilder<String, String>? extensions) => _$this._extensions = extensions;

  HealthOutBuilder() {
    HealthOut._defaults(this);
  }

  HealthOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _extensions = $v.extensions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HealthOut other) {
    _$v = other as _$HealthOut;
  }

  @override
  void update(void Function(HealthOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HealthOut build() => _build();

  _$HealthOut _build() {
    _$HealthOut _$result;
    try {
      _$result = _$v ??
          _$HealthOut._(
            status: BuiltValueNullFieldError.checkNotNull(status, r'HealthOut', 'status'),
            extensions: extensions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'extensions';
        extensions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'HealthOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
