// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Dashboard extends Dashboard {
  @override
  final String period;
  @override
  final DataSource? dataSource;
  @override
  final Date? dataCompleteUntil;
  @override
  final ConsumerSummary? consumer;
  @override
  final ProducerSummary? producer;
  @override
  final num co2AvoidedKg;
  @override
  final num co2KgPerKwh;

  factory _$Dashboard([void Function(DashboardBuilder)? updates]) =>
      (DashboardBuilder()..update(updates))._build();

  _$Dashboard._(
      {required this.period,
      this.dataSource,
      this.dataCompleteUntil,
      this.consumer,
      this.producer,
      required this.co2AvoidedKg,
      required this.co2KgPerKwh})
      : super._();
  @override
  Dashboard rebuild(void Function(DashboardBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardBuilder toBuilder() => DashboardBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Dashboard &&
        period == other.period &&
        dataSource == other.dataSource &&
        dataCompleteUntil == other.dataCompleteUntil &&
        consumer == other.consumer &&
        producer == other.producer &&
        co2AvoidedKg == other.co2AvoidedKg &&
        co2KgPerKwh == other.co2KgPerKwh;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, dataSource.hashCode);
    _$hash = $jc(_$hash, dataCompleteUntil.hashCode);
    _$hash = $jc(_$hash, consumer.hashCode);
    _$hash = $jc(_$hash, producer.hashCode);
    _$hash = $jc(_$hash, co2AvoidedKg.hashCode);
    _$hash = $jc(_$hash, co2KgPerKwh.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Dashboard')
          ..add('period', period)
          ..add('dataSource', dataSource)
          ..add('dataCompleteUntil', dataCompleteUntil)
          ..add('consumer', consumer)
          ..add('producer', producer)
          ..add('co2AvoidedKg', co2AvoidedKg)
          ..add('co2KgPerKwh', co2KgPerKwh))
        .toString();
  }
}

class DashboardBuilder implements Builder<Dashboard, DashboardBuilder> {
  _$Dashboard? _$v;

  String? _period;
  String? get period => _$this._period;
  set period(String? period) => _$this._period = period;

  DataSource? _dataSource;
  DataSource? get dataSource => _$this._dataSource;
  set dataSource(DataSource? dataSource) => _$this._dataSource = dataSource;

  Date? _dataCompleteUntil;
  Date? get dataCompleteUntil => _$this._dataCompleteUntil;
  set dataCompleteUntil(Date? dataCompleteUntil) => _$this._dataCompleteUntil = dataCompleteUntil;

  ConsumerSummaryBuilder? _consumer;
  ConsumerSummaryBuilder get consumer => _$this._consumer ??= ConsumerSummaryBuilder();
  set consumer(ConsumerSummaryBuilder? consumer) => _$this._consumer = consumer;

  ProducerSummaryBuilder? _producer;
  ProducerSummaryBuilder get producer => _$this._producer ??= ProducerSummaryBuilder();
  set producer(ProducerSummaryBuilder? producer) => _$this._producer = producer;

  num? _co2AvoidedKg;
  num? get co2AvoidedKg => _$this._co2AvoidedKg;
  set co2AvoidedKg(num? co2AvoidedKg) => _$this._co2AvoidedKg = co2AvoidedKg;

  num? _co2KgPerKwh;
  num? get co2KgPerKwh => _$this._co2KgPerKwh;
  set co2KgPerKwh(num? co2KgPerKwh) => _$this._co2KgPerKwh = co2KgPerKwh;

  DashboardBuilder() {
    Dashboard._defaults(this);
  }

  DashboardBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _period = $v.period;
      _dataSource = $v.dataSource;
      _dataCompleteUntil = $v.dataCompleteUntil;
      _consumer = $v.consumer?.toBuilder();
      _producer = $v.producer?.toBuilder();
      _co2AvoidedKg = $v.co2AvoidedKg;
      _co2KgPerKwh = $v.co2KgPerKwh;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Dashboard other) {
    _$v = other as _$Dashboard;
  }

  @override
  void update(void Function(DashboardBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Dashboard build() => _build();

  _$Dashboard _build() {
    _$Dashboard _$result;
    try {
      _$result = _$v ??
          _$Dashboard._(
            period: BuiltValueNullFieldError.checkNotNull(period, r'Dashboard', 'period'),
            dataSource: dataSource,
            dataCompleteUntil: dataCompleteUntil,
            consumer: _consumer?.build(),
            producer: _producer?.build(),
            co2AvoidedKg:
                BuiltValueNullFieldError.checkNotNull(co2AvoidedKg, r'Dashboard', 'co2AvoidedKg'),
            co2KgPerKwh:
                BuiltValueNullFieldError.checkNotNull(co2KgPerKwh, r'Dashboard', 'co2KgPerKwh'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'consumer';
        _consumer?.build();
        _$failedField = 'producer';
        _producer?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Dashboard', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
