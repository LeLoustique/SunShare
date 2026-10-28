import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunshare/core/format.dart';
import 'package:sunshare/features/admin/admin_repository.dart';
import 'package:sunshare_api/sunshare_api.dart';

import 'helpers.dart';

final invoice = statementOut();
final payout = statementOut(
  id: 'releve-2',
  number: 'SS-2026-000002',
  direction: MeterDirection.production,
  commission: '2.85',
  net: '22.80',
);

Future<FakeStatementsRepository> openStatements(
  WidgetTester tester,
  List<StatementOut> statements,
) async {
  final repository = FakeStatementsRepository(statements);
  await pumpApp(
    tester,
    auth: FakeAuthRepository(loggedIn: true, role: UserRole.mixed),
    statements: repository,
  );
  await tester.tap(find.text('Factures'));
  await tester.pumpAndSettle();
  return repository;
}

Future<FakeAdminRepository> openBilling(WidgetTester tester, List<AdminStatementOut> drafts) async {
  final admin = FakeAdminRepository(computedDrafts: drafts);
  await pumpApp(
    tester,
    auth: FakeAuthRepository(loggedIn: true, role: UserRole.admin),
    admin: admin,
  );
  await tester.tap(find.text('Facturation'));
  await tester.pumpAndSettle();
  return admin;
}

void main() {
  group('participant', () {
    testWidgets('aucune facture : explique le rythme mensuel', (tester) async {
      await openStatements(tester, []);

      expect(find.widgetWithText(AppBar, 'Factures'), findsOneWidget);
      expect(find.textContaining('Aucune facture pour le moment'), findsOneWidget);
    });

    testWidgets('liste : factures à payer et reversements', (tester) async {
      await openStatements(tester, [invoice, payout]);

      expect(find.text('Facture — octobre 2026'), findsOneWidget);
      expect(find.text('Reversement — octobre 2026'), findsOneWidget);
      expect(find.text('25,65 €'), findsOneWidget);
      expect(find.text('à payer'), findsOneWidget);
      expect(find.text('22,80 €'), findsOneWidget);
      expect(find.text('reversés'), findsOneWidget);
    });

    testWidgets('détail d’une facture et ouverture du PDF', (tester) async {
      final repository = await openStatements(tester, [invoice]);

      await tester.tap(find.text('Facture — octobre 2026'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Facture SS-2026-000001'), findsOneWidget);
      expect(find.text('142,500 kWh'), findsOneWidget);
      expect(find.text('0,18 €/kWh'), findsOneWidget);
      expect(find.text('Total à payer'), findsOneWidget);
      expect(find.textContaining('Commission'), findsNothing);

      await tester.tap(find.text('Ouvrir le PDF'));
      await tester.pumpAndSettle();
      expect(repository.opened, ['SS-2026-000001.pdf']);
    });

    testWidgets('détail d’un reversement : brut, commission, net', (tester) async {
      await openStatements(tester, [payout]);

      await tester.tap(find.text('Reversement — octobre 2026'));
      await tester.pumpAndSettle();

      expect(find.text('Montant brut'), findsOneWidget);
      expect(find.text('Commission (0,02 €/kWh)'), findsOneWidget);
      expect(find.text('-2,85 €'), findsOneWidget);
      expect(find.text('Net reversé'), findsOneWidget);
      expect(find.text('22,80 €'), findsOneWidget);
    });
  });

  group('back-office', () {
    final month = defaultBillingMonth(DateTime.now());
    final period = periodOf(month.year, month.month);

    testWidgets('mois précédent par défaut, rien à émettre', (tester) async {
      await openBilling(tester, []);

      expect(find.widgetWithText(AppBar, 'Facturation'), findsOneWidget);
      expect(find.text(formatPeriod(period)), findsOneWidget);
      expect(find.text('Aucun relevé pour ce mois'), findsOneWidget);
      final issue = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Émettre 0 brouillon'));
      expect(issue.onPressed, isNull);
      final next = tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.chevron_right));
      expect(next.onPressed, isNull);
    });

    testWidgets('calculer, vérifier un brouillon, émettre', (tester) async {
      final admin = await openBilling(tester, [
        draftStatement(id: 'd1'),
        draftStatement(id: 'd2', firstName: 'Camille', direction: MeterDirection.production),
      ]);

      await tester.tap(find.text('Calculer les brouillons'));
      await tester.pumpAndSettle();
      expect(admin.billingRuns, [period]);
      expect(find.textContaining('Saint-Leu : 2 relevé(s)'), findsOneWidget);
      expect(find.text('Facture — Alex Durand'), findsOneWidget);
      expect(find.text('Reversement — Camille Durand'), findsOneWidget);
      expect(find.text('Aperçu PDF'), findsNWidgets(2));

      await tester.tap(find.text('Émettre 2 brouillons'));
      await tester.pumpAndSettle();
      expect(find.textContaining('ne pourront plus être modifiés'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Émettre'));
      await tester.pumpAndSettle();

      expect(find.text('2 relevé(s) émis : SS-2026-000001 à SS-2026-000002'), findsOneWidget);
      expect(find.textContaining('N° SS-2026-000001'), findsOneWidget);
      expect(find.text('PDF'), findsNWidgets(2));
      expect(find.text('Émettre 0 brouillon'), findsOneWidget);
    });

    testWidgets('aperçu PDF d’un brouillon', (tester) async {
      final statements = FakeStatementsRepository();
      final admin = FakeAdminRepository(computedDrafts: [draftStatement(id: 'd1')]);
      await pumpApp(
        tester,
        auth: FakeAuthRepository(loggedIn: true, role: UserRole.admin),
        admin: admin,
        statements: statements,
      );
      await tester.tap(find.text('Facturation'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Calculer les brouillons'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Aperçu PDF'));
      await tester.pumpAndSettle();
      expect(statements.opened, ['brouillon-d1.pdf']);
    });

    testWidgets('changer de mois', (tester) async {
      final admin = await openBilling(tester, [draftStatement(id: 'd1')]);
      final before = DateTime(month.year, month.month - 1);

      await tester.tap(find.byTooltip('Mois précédent'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Calculer les brouillons'));
      await tester.pumpAndSettle();

      expect(admin.billingRuns, [periodOf(before.year, before.month)]);
    });
  });

  test('formats', () {
    expect(formatKwhPrecise(142.5), '142,500 kWh');
    expect(formatPeriod('2026-10'), 'octobre 2026');
    expect(defaultBillingMonth(DateTime(2027, 1, 5)), (year: 2026, month: 12));
  });
}
