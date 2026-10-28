import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunshare/core/format.dart';
import 'package:sunshare/features/admin/admin_repository.dart';
import 'package:sunshare_api/sunshare_api.dart';

import 'helpers.dart';

Finder field(String label) => find.widgetWithText(TextFormField, label);

Future<FakeAdminRepository> openBackOffice(
  WidgetTester tester, {
  List<AdminLoopOut>? loops,
  List<AdminMemberOut>? members,
}) async {
  final admin = FakeAdminRepository(loops: loops, members: members);
  await pumpApp(tester, auth: FakeAuthRepository(loggedIn: true, role: UserRole.admin), admin: admin);
  return admin;
}

Future<void> openLoop(WidgetTester tester, String name) async {
  await tester.tap(find.text(name));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('l’administrateur arrive sur le back-office, sans « Ma boucle »', (tester) async {
    await openBackOffice(tester);

    expect(find.widgetWithText(AppBar, 'Boucles'), findsOneWidget);
    expect(find.text('Ma boucle'), findsNothing);
    expect(find.textContaining('Aucune boucle pour le moment'), findsOneWidget);
  });

  testWidgets('un utilisateur n’a pas accès au back-office', (tester) async {
    await pumpApp(tester, auth: FakeAuthRepository(loggedIn: true));

    expect(find.text('Boucles'), findsNothing);
    expect(find.widgetWithText(AppBar, 'Ma boucle'), findsOneWidget);
  });

  testWidgets('liste : statut, demandes en attente, tarif et commission', (tester) async {
    await openBackOffice(tester, loops: [adminLoop(pendingCount: 2)]);

    expect(find.text('Saint-Leu'), findsOneWidget);
    expect(find.text('Ouverte'), findsOneWidget);
    expect(find.text('0 membre · 2 demandes en attente'), findsOneWidget);
    expect(find.text('Tarif 0,18 €/kWh · commission 0,02 €/kWh'), findsOneWidget);
  });

  testWidgets('création d’une boucle', (tester) async {
    final admin = await openBackOffice(tester);

    await tester.tap(find.text('Nouvelle boucle'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Nom de la boucle'), 'Henriville');
    await tester.enterText(field('Tarif'), '0,165');
    await tester.enterText(field('Commission'), '0,02');
    await tester.tap(find.text('Créer la boucle'));
    await tester.pumpAndSettle();

    final created = admin.loopList.single;
    expect(created.name, 'Henriville');
    expect(created.priceEurKwh, '0.165'); // envoyé tel quel, sans flottant
    expect(created.commissionEurKwh, '0.02');
    expect(created.perimeterKm, 2);
    // Ouvre directement la boucle créée
    expect(find.widgetWithText(AppBar, 'Henriville'), findsOneWidget);
  });

  testWidgets('création : tarif invalide et commission trop élevée refusés', (tester) async {
    final admin = await openBackOffice(tester);

    await tester.tap(find.text('Nouvelle boucle'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Nom de la boucle'), 'Henriville');
    await tester.enterText(field('Tarif'), '0,18');
    await tester.enterText(field('Commission'), '0,2');
    await tester.tap(find.text('Créer la boucle'));
    await tester.pumpAndSettle();
    expect(find.text('La commission doit être inférieure au tarif'), findsOneWidget);

    await tester.enterText(field('Tarif'), '0,123456');
    await tester.tap(find.text('Créer la boucle'));
    await tester.pumpAndSettle();
    expect(find.textContaining('4 décimales au plus'), findsWidgets);
    expect(admin.loopList, isEmpty);
  });

  testWidgets('modification d’une boucle', (tester) async {
    final admin = await openBackOffice(tester, loops: [adminLoop()]);
    await openLoop(tester, 'Saint-Leu');

    await tester.tap(find.byTooltip('Modifier'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, '0,18'), findsOneWidget);
    await tester.enterText(field('Tarif'), '0,20');
    await tester.tap(find.text('Ouverte aux nouvelles demandes'));
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(admin.loopList.single.priceEurKwh, '0.20');
    expect(admin.loopList.single.status, LoopStatus.closed);
    expect(find.text('Fermée aux nouvelles demandes'), findsOneWidget);
  });

  testWidgets('validation d’une demande avec la date d’entrée', (tester) async {
    final admin = await openBackOffice(
      tester,
      loops: [adminLoop(pendingCount: 1)],
      members: [adminMember(id: 'a1')],
    );
    await openLoop(tester, 'Saint-Leu');
    expect(find.text('Demandes en attente (1)'), findsOneWidget);
    expect(find.text('Alex Durand'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Valider'));
    await tester.pumpAndSettle();
    final expected = defaultJoinDate(DateTime.now());
    expect(find.text(formatDay(expected)), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Valider').last);
    await tester.pumpAndSettle();

    expect(admin.approvals['a1'], expected);
    expect(find.text('Demandes en attente (0)'), findsOneWidget);
    expect(find.text('Membres actifs (1)'), findsOneWidget);
    expect(find.textContaining('Entrée le ${formatDay(expected)}'), findsOneWidget);
  });

  testWidgets('refus d’une demande après confirmation', (tester) async {
    final admin = await openBackOffice(
      tester,
      loops: [adminLoop(pendingCount: 1)],
      members: [adminMember(id: 'a1')],
    );
    await openLoop(tester, 'Saint-Leu');

    await tester.tap(find.widgetWithText(TextButton, 'Refuser'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Refuser'));
    await tester.pumpAndSettle();

    expect(admin.memberList.single.status, MembershipStatus.rejected);
    expect(find.text('Demandes refusées (1)'), findsOneWidget);
  });

  group('tarifs saisis', () {
    test('conversion exacte vers l’API', () {
      expect(parseEurPerKwh('0,18'), '0.18');
      expect(parseEurPerKwh(' 0.1650 '), '0.1650');
      expect(parseEurPerKwh('1'), '1');
      expect(parseEurPerKwh('0,12345'), isNull);
      expect(parseEurPerKwh('10'), isNull); // le serveur refuse 10 €/kWh et plus
      expect(parseEurPerKwh('abc'), isNull);
    });

    test('comparaison sans flottant', () {
      expect(eurPerKwhUnits('0.18'), 1800);
      expect(eurPerKwhUnits('0.1650'), 1650);
      expect(eurPerKwhUnits('1'), 10000);
    });

    test('date d’entrée par défaut : le 1er du mois suivant', () {
      expect(defaultJoinDate(DateTime(2026, 10, 28)), Date(2026, 11, 1));
      expect(defaultJoinDate(DateTime(2026, 12, 15)), Date(2027, 1, 1));
    });
  });
}
