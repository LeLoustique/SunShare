// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_curves.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DayCurves extends DayCurves {
  @override
  final Date day;
  @override
  final DataSource? dataSource;
  @override
  final BuiltList<CurveStep> steps;

  factory _$DayCurves([void Function(DayCurvesBuilder)? updates]) =>
      (DayCurvesBuilder()..update(updates))._build();

  _$DayCurves._({required this.day, this.dataSource, required this.steps}) : super._();
  @override
  DayCurves rebuild(void Function(DayCurvesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DayCurvesBuilder toBuilder() => DayCurvesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DayCurves &&
        day == other.day &&
        dataSource == other.dataSource &&
        steps == other.steps;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, day.hashCode);
    _$hash = $jc(_$hash, dataSource.hashCode);
    _$hash = $jc(_$hash, steps.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DayCurves')
          ..add('day', day)
          ..add('dataSource', dataSource)
          ..add('steps', steps))
        .toString();
  }
}

class DayCurvesBuilder implements Builder<DayCurves, DayCurvesBuilder> {
  _$DayCurves? _$v;

  Date? _day;
  Date? get day => _$this._day;
  set day(Date? day) => _$this._day = day;

  DataSource? _dataSource;
  DataSource? get dataSource => _$this._dataSource;
  set dataSource(DataSource? dataSource) => _$this._dataSource = dataSource;

  ListBuilder<CurveStep>? _steps;
  ListBuilder<CurveStep> get steps => _$this._steps ??= ListBuilder<CurveStep>();
  set steps(ListBuilder<CurveStep>? steps) => _$this._steps = steps;

  DayCurvesBuilder() {
    DayCurves._defaults(this);
  }

  DayCurvesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _day = $v.day;
      _dataSource = $v.dataSource;
      _steps = $v.steps.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DayCurves other) {
    _$v = other as _$DayCurves;
  }

  @override
  void update(void Function(DayCurvesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DayCurves build() => _build();

  _$DayCurves _build() {
    _$DayCurves _$result;
    try {
      _$result = _$v ??
          _$DayCurves._(
            day: BuiltValueNullFieldError.checkNotNull(day, r'DayCurves', 'day'),
            dataSource: dataSource,
            steps: steps.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'steps';
        steps.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'DayCurves', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
