import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunshare/core/format.dart';
import 'package:sunshare/features/dashboard/dashboard_repository.dart';
import 'package:sunshare_api/sunshare_api.dart';

import 'helpers.dart';

final latest = latestDay(DateTime.now());

Dashboard month({ConsumerSummary? consumer, ProducerSummary? producer, DataSource? source}) =>
    Dashboard((b) => b
      ..period = '2026-10'
      ..dataSource = source ?? DataSource.simulated
      ..dataCompleteUntil = Date(2026, 10, 27)
      ..consumer = consumer?.toBuilder()
      ..producer = producer?.toBuilder()
      ..co2AvoidedKg = 7.4
      ..co2KgPerKwh = 0.052);

final consumerFigures = ConsumerSummary((b) => b
  ..consumptionKwh = 250
  ..localKwh = 142.5
  ..selfConsumptionRate = 0.57
  ..amountEur = '25.65');

final producerFigures = ProducerSummary((b) => b
  ..productionKwh = 300
  ..soldKwh = 142.5
  ..localShare = 0.475
  ..commissionEur = '2.85'
  ..netEur = '22.80');

/// Journée d'un consommateur au pas de 15 min : 1 kW toute la journée (24 kWh), dont 0,125 kWh
/// local par pas de 12 h à 16 h (16 pas, 2 kWh).
DayCurves consumerDay() => DayCurves((b) => b
  ..day = latest
  ..dataSource = DataSource.simulated
  ..steps.addAll([
    for (var i = 0; i < 96; i++)
      CurveStep((s) => s
        ..ts = DateTime.utc(2026, 10, 26, 23).add(Duration(minutes: 15 * i))
        ..consumptionKw = 1
        ..receivedKwh = i >= 48 && i < 64 ? 0.125 : 0
        ..soldKwh = 0),
  ]));

Future<FakeDashboardRepository> openDashboard(
  WidgetTester tester, {
  Dashboard? monthData,
  DayCurves? dayData,
}) async {
  final dashboard = FakeDashboardRepository(monthData: monthData, dayData: dayData);
  await pumpApp(tester, auth: FakeAuthRepository(loggedIn: true, role: UserRole.mixed), dashboard: dashboard);
  return dashboard;
}

void main() {
  testWidgets('accueil : tableau de bord du mois en cours et de la veille', (tester) async {
    final dashboard = await openDashboard(tester);

    expect(find.widgetWithText(AppBar, 'Tableau de bord'), findsOneWidget);
    expect(find.text(formatMonth(latest.year, latest.month)), findsOneWidget);
    expect(dashboard.requestedPeriods, [periodOf(latest.year, latest.month)]);
    expect(dashboard.requestedDays, [latest]);
  });

  testWidgets('sans compteur ni boucle : invite à rejoindre une boucle', (tester) async {
    await openDashboard(tester);

    expect(find.text('Pas de mesure pour cette journée'), findsOneWidget);
    await tester.tap(find.text('Voir les boucles'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Ma boucle'), findsOneWidget);
  });

  testWidgets('consommateur : énergie locale, taux, montant estimé, CO2', (tester) async {
    await openDashboard(tester, monthData: month(consumer: consumerFigures));

    expect(find.textContaining('Estimation à partir de données simulées'), findsOneWidget);
    expect(find.text('142,5 kWh'), findsOneWidget);
    expect(
      find.text('Soit ${formatPercent(0.57)} de votre consommation (250 kWh)'),
      findsOneWidget,
    );
    expect(find.text('Montant estimé : 25,65 €'), findsOneWidget);
    expect(find.text('7,4 kg'), findsOneWidget);
    expect(find.text('Données jusqu’au 27/10/2026'), findsOneWidget);
    expect(find.textContaining('Revenu net'), findsNothing);
  });

  testWidgets('producteur, données Enedis : revenu net du mois, sans bandeau', (tester) async {
    await openDashboard(
      tester,
      monthData: month(producer: producerFigures, source: DataSource.enedis),
    );

    expect(find.textContaining('Estimation'), findsNothing);
    expect(find.text('Revenu net du mois : 22,80 €'), findsOneWidget);
    expect(find.text('Après 2,85 € de commission'), findsOneWidget);
    expect(find.text('vendus dans la boucle'), findsOneWidget);
  });

  testWidgets('navigation entre les mois, jamais au-delà du mois en cours', (tester) async {
    final dashboard = await openDashboard(tester, monthData: month(consumer: consumerFigures));
    final previous = DateTime(latest.year, latest.month - 1);

    final next = tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.chevron_right).first);
    expect(next.onPressed, isNull);

    await tester.tap(find.byTooltip('Précédent').first);
    await tester.pumpAndSettle();
    expect(dashboard.requestedPeriods.last, periodOf(previous.year, previous.month));
    expect(find.text(formatMonth(previous.year, previous.month)), findsOneWidget);
  });

  testWidgets('courbe du jour : graphique, légende et totaux', (tester) async {
    final dashboard = await openDashboard(
      tester,
      monthData: month(consumer: consumerFigures),
      dayData: consumerDay(),
    );

    expect(find.byType(LineChart), findsOneWidget);
    expect(find.text('Consommation'), findsOneWidget);
    expect(find.text('Énergie locale'), findsOneWidget);
    expect(find.text('Production'), findsNothing);
    expect(find.text('Consommation 24 kWh, dont 2 kWh d’énergie locale'), findsOneWidget);

    await tester.tap(find.byTooltip('Précédent').last);
    await tester.pumpAndSettle();
    final dayBefore = latest.toDateTime().subtract(const Duration(days: 1)).toDate();
    expect(dashboard.requestedDays.last, dayBefore);
    expect(find.text(formatDay(dayBefore)), findsOneWidget);
  });

  group('formats', () {
    test('euros, kWh, pourcentages, mois', () {
      expect(formatEuros('25.65'), '25,65 €');
      expect(formatKwh(142.46), '142,5 kWh');
      expect(formatKwh(24), '24 kWh');
      expect(formatPercent(0.574), '57 %');
      expect(formatMonth(2026, 10), 'octobre 2026');
      expect(periodOf(2026, 3), '2026-03');
    });

    test('la veille est le jour le plus récent', () {
      expect(latestDay(DateTime(2026, 11, 1, 8)), Date(2026, 10, 31));
    });
  });
}
