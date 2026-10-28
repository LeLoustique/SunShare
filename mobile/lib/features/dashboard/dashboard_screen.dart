import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api_errors.dart';
import '../../core/format.dart';
import 'dashboard_repository.dart';

const consumptionColor = Colors.blueGrey;
const productionColor = Color(0xFFF2A900);
const localColor = Color(0xFF2E9E5B);

/// Onglet « Tableau de bord » : chiffres du mois (DASH-02) et courbe d'une journée (DASH-01).
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _latest = latestDay(DateTime.now());
  late int _year = _latest.year;
  late int _month = _latest.month;
  late Date _day = _latest;

  bool get _isLatestMonth => _year == _latest.year && _month == _latest.month;

  void _shiftMonth(int delta) => setState(() {
        final shifted = DateTime(_year, _month + delta);
        _year = shifted.year;
        _month = shifted.month;
      });

  void _shiftDay(int delta) => setState(() {
        _day = _day.toDateTime().add(Duration(days: delta)).toDate();
      });

  @override
  Widget build(BuildContext context) {
    final period = periodOf(_year, _month);
    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de bord')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(monthDashboardProvider(period));
          ref.invalidate(dayCurvesProvider(_day));
          await ref.read(monthDashboardProvider(period).future);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Navigator(
              label: formatMonth(_year, _month),
              onPrevious: () => _shiftMonth(-1),
              onNext: _isLatestMonth ? null : () => _shiftMonth(1),
            ),
            _MonthSection(period: period),
            const SizedBox(height: 24),
            Text('Courbe de la journée', style: Theme.of(context).textTheme.titleMedium),
            _Navigator(
              label: formatDay(_day),
              onPrevious: () => _shiftDay(-1),
              onNext: _day == _latest ? null : () => _shiftDay(1),
            ),
            _DaySection(day: _day),
          ],
        ),
      ),
    );
  }
}

class _Navigator extends StatelessWidget {
  const _Navigator({required this.label, required this.onPrevious, required this.onNext});

  final String label;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(tooltip: 'Précédent', onPressed: onPrevious, icon: const Icon(Icons.chevron_left)),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(tooltip: 'Suivant', onPressed: onNext, icon: const Icon(Icons.chevron_right)),
      ],
    );
  }
}

class _MonthSection extends ConsumerWidget {
  const _MonthSection({required this.period});

  final String period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(monthDashboardProvider(period))) {
      AsyncData(value: final month) => _MonthFigures(month: month),
      AsyncError(:final error) => _Retry(
          message: errorMessage(error),
          onRetry: () => ref.invalidate(monthDashboardProvider(period)),
        ),
      _ => const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
    };
  }
}

class _MonthFigures extends StatelessWidget {
  const _MonthFigures({required this.month});

  final Dashboard month;

  @override
  Widget build(BuildContext context) {
    final consumer = month.consumer;
    final producer = month.producer;
    if (consumer == null && producer == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Ajoutez votre compteur et rejoignez une boucle pour suivre l’énergie que vous '
                'partagez avec vos voisins.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => context.go('/boucle'),
                child: const Text('Voir les boucles'),
              ),
            ],
          ),
        ),
      );
    }

    final until = month.dataCompleteUntil;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SourceBanner(source: month.dataSource),
        if (consumer != null)
          _FigureCard(
            icon: Icons.home_outlined,
            color: localColor,
            headline: formatKwh(consumer.localKwh),
            caption: 'd’énergie locale reçue',
            lines: [
              if (consumer.selfConsumptionRate != null)
                'Soit ${formatPercent(consumer.selfConsumptionRate!)} de votre consommation '
                    '(${formatKwh(consumer.consumptionKwh)})',
              'Montant ${_estimated(month)} : ${formatEuros(consumer.amountEur)}',
            ],
          ),
        if (producer != null)
          _FigureCard(
            icon: Icons.solar_power_outlined,
            color: productionColor,
            headline: formatKwh(producer.soldKwh),
            caption: 'vendus dans la boucle',
            lines: [
              if (producer.localShare != null)
                'Soit ${formatPercent(producer.localShare!)} de votre production '
                    '(${formatKwh(producer.productionKwh)})',
              'Revenu net ${_estimated(month)} : ${formatEuros(producer.netEur)}',
              'Après ${formatEuros(producer.commissionEur)} de commission',
            ],
          ),
        _FigureCard(
          icon: Icons.eco_outlined,
          color: localColor,
          headline: '${month.co2AvoidedKg.toString().replaceAll('.', ',')} kg',
          caption: 'de CO2 évités',
          lines: [
            'Hypothèse : ${month.co2KgPerKwh.toString().replaceAll('.', ',')} kg par kWh local',
          ],
        ),
        if (until != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Données jusqu’au ${formatDay(until)}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  /// Seules les données Enedis servent à facturer : tout le reste est une estimation.
  static String _estimated(Dashboard month) =>
      month.dataSource == DataSource.enedis ? 'du mois' : 'estimé';
}

class _SourceBanner extends StatelessWidget {
  const _SourceBanner({required this.source});

  final DataSource? source;

  @override
  Widget build(BuildContext context) {
    final message = switch (source) {
      DataSource.enedis => null,
      null => 'Pas encore de données pour ce mois.',
      _ => 'Estimation à partir de données simulées : la facturation reposera uniquement sur '
          'les données Enedis.',
    };
    if (message == null) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.secondaryContainer,
      child: ListTile(
        leading: const Icon(Icons.info_outline),
        title: Text(message, style: TextStyle(color: colors.onSecondaryContainer)),
      ),
    );
  }
}

class _FigureCard extends StatelessWidget {
  const _FigureCard({
    required this.icon,
    required this.color,
    required this.headline,
    required this.caption,
    required this.lines,
  });

  final IconData icon;
  final Color color;
  final String headline;
  final String caption;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(headline, style: theme.textTheme.headlineSmall),
                  Text(caption),
                  const SizedBox(height: 4),
                  for (final line in lines) Text(line, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DaySection extends ConsumerWidget {
  const _DaySection({required this.day});

  final Date day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(dayCurvesProvider(day))) {
      AsyncData(value: final curves) when curves.dataSource == null => const Card(
          child: ListTile(
            leading: Icon(Icons.hourglass_empty),
            title: Text('Pas de mesure pour cette journée'),
            subtitle: Text('Les données d’une journée arrivent le lendemain.'),
          ),
        ),
      AsyncData(value: final curves) => _DayChart(curves: curves),
      AsyncError(:final error) => _Retry(
          message: errorMessage(error),
          onRetry: () => ref.invalidate(dayCurvesProvider(day)),
        ),
      _ => const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
    };
  }
}

/// Puissances de la journée, heure par heure, et énergie locale en aplat.
class _DayChart extends StatelessWidget {
  const _DayChart({required this.curves});

  final DayCurves curves;

  @override
  Widget build(BuildContext context) {
    final steps = curves.steps.toList();
    final hasConsumption = steps.any((s) => s.consumptionKw != null);
    final hasProduction = steps.any((s) => s.productionKw != null);

    // Abscisse : heures depuis minuit (0 → 24, ou 23 / 25 aux changements d'heure)
    List<FlSpot> spots(num? Function(CurveStep) value) => [
          for (final (i, step) in steps.indexed)
            value(step) == null ? FlSpot.nullSpot : FlSpot(i / 2, value(step)!.toDouble()),
        ];
    LineChartBarData line(List<FlSpot> data, Color color, {bool filled = false}) => LineChartBarData(
          spots: data,
          color: color,
          barWidth: filled ? 0 : 2,
          isCurved: false,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: filled, color: color.withValues(alpha: 0.35)),
        );

    // Énergie locale du pas convertie en puissance moyenne (kWh / 0,5 h) pour la même échelle
    final local = spots((s) => (s.receivedKwh + s.soldKwh) * 2);
    final consumption = steps.fold<num>(0, (sum, s) => sum + (s.consumptionKw ?? 0) / 2);
    final production = steps.fold<num>(0, (sum, s) => sum + (s.productionKw ?? 0) / 2);
    final received = steps.fold<num>(0, (sum, s) => sum + s.receivedKwh);
    final sold = steps.fold<num>(0, (sum, s) => sum + s.soldKwh);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: steps.length / 2,
                  minY: 0,
                  lineTouchData: const LineTouchData(enabled: false),
                  gridData: const FlGridData(drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text('kW'),
                      sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 6,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          meta: meta,
                          child: Text('${value.toInt()}h'),
                        ),
                      ),
                    ),
                  ),
                  lineBarsData: [
                    line(local, localColor, filled: true),
                    if (hasConsumption) line(spots((s) => s.consumptionKw), consumptionColor),
                    if (hasProduction) line(spots((s) => s.productionKw), productionColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              children: [
                if (hasConsumption) const _Legend(consumptionColor, 'Consommation'),
                if (hasProduction) const _Legend(productionColor, 'Production'),
                const _Legend(localColor, 'Énergie locale'),
              ],
            ),
            const SizedBox(height: 8),
            if (hasConsumption)
              Text(
                'Consommation ${formatKwh(consumption)}, dont ${formatKwh(received)} d’énergie locale',
                textAlign: TextAlign.center,
              ),
            if (hasProduction)
              Text(
                'Production ${formatKwh(production)}, dont ${formatKwh(sold)} vendus dans la boucle',
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend(this.color, this.label);

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class _Retry extends StatelessWidget {
  const _Retry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          FilledButton(onPressed: onRetry, child: const Text('Réessayer')),
        ],
      ),
    );
  }
}
