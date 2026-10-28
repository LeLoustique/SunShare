import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunshare/core/format.dart';
import 'package:sunshare_api/sunshare_api.dart';

import 'helpers.dart';

final home = meter(prm: '11111111111111');
final panels = meter(prm: '22222222222222', direction: MeterDirection.production, peakKw: 6);

/// Ouvre l'app connectée sur « Ma boucle ».
Future<FakeLoopsRepository> openLoopTab(
  WidgetTester tester, {
  List<MeterOut>? meters,
  List<AvailableLoop>? available,
  List<MembershipOut>? memberships,
  Set<String> refusedLoops = const {},
}) async {
  final metersRepository = FakeMetersRepository(meters ?? [home]);
  final loops = FakeLoopsRepository(
    metersRepository,
    available: available,
    memberships: memberships,
    refusedLoops: refusedLoops,
  );
  await pumpApp(
    tester,
    auth: FakeAuthRepository(loggedIn: true, role: UserRole.mixed),
    meters: metersRepository,
    loops: loops,
  );
  return loops;
}

Future<void> requestToJoin(WidgetTester tester) async {
  await tester.tap(find.text('Demander à rejoindre'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Envoyer la demande'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('sans compteur : invite à en ajouter un', (tester) async {
    await openLoopTab(tester, meters: []);

    expect(find.text('Ajoutez votre compteur'), findsOneWidget);
    await tester.tap(find.text('Ajouter un compteur'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Ajouter un compteur'), findsOneWidget);
  });

  testWidgets('aucune boucle à portée', (tester) async {
    await openLoopTab(tester);

    expect(find.text('Aucune boucle ne couvre encore votre adresse'), findsOneWidget);
  });

  testWidgets('boucle disponible : demande d’adhésion', (tester) async {
    final loops = await openLoopTab(tester, available: [availableLoop(joinable: [home.id])]);

    expect(find.text('Saint-Leu'), findsOneWidget);
    expect(find.text('0,18 €/kWh'), findsOneWidget);

    await tester.tap(find.text('Demander à rejoindre'));
    await tester.pumpAndSettle();
    expect(find.text('Rejoindre « Saint-Leu » ?'), findsOneWidget);
    expect(find.text('• PRM ${home.prm}'), findsOneWidget);
    await tester.tap(find.text('Envoyer la demande'));
    await tester.pumpAndSettle();

    expect(loops.membershipList.single.meterId, home.id);
    expect(find.text('Demande envoyée'), findsOneWidget);
    expect(find.text('En attente'), findsOneWidget);
    expect(find.text('Demander à rejoindre'), findsNothing);
    // Les chiffres de la boucle sont visibles dès la demande
    expect(find.text('3 (1 producteur, 2 consommateurs)'), findsOneWidget);
  });

  testWidgets('utilisateur mixte : ses deux compteurs rejoignent la boucle', (tester) async {
    final loops = await openLoopTab(
      tester,
      meters: [home, panels],
      available: [availableLoop(joinable: [home.id, panels.id])],
    );

    await tester.tap(find.text('Demander à rejoindre'));
    await tester.pumpAndSettle();
    expect(find.text('Compteurs concernés :'), findsOneWidget);
    await tester.tap(find.text('Envoyer la demande'));
    await tester.pumpAndSettle();

    expect(loops.membershipList.map((m) => m.meterId), containsAll([home.id, panels.id]));
  });

  testWidgets('hors périmètre : affiche le refus de l’API', (tester) async {
    await openLoopTab(
      tester,
      available: [availableLoop(joinable: [home.id])],
      refusedLoops: {'boucle-1'},
    );

    await requestToJoin(tester);

    expect(find.text('Votre compteur est hors du périmètre de la boucle'), findsOneWidget);
    expect(find.text('Demander à rejoindre'), findsOneWidget);
  });

  testWidgets('demande en attente : annulation', (tester) async {
    final loops = await openLoopTab(
      tester,
      available: [availableLoop(joinable: [home.id])],
      memberships: [membership(home)],
    );
    expect(find.text('En attente'), findsOneWidget);

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Annuler la demande'));
    await tester.pumpAndSettle();

    expect(loops.membershipList, isEmpty);
    expect(find.text('Demander à rejoindre'), findsOneWidget);
  });

  testWidgets('membre actif : chiffres de la boucle et date d’entrée', (tester) async {
    await openLoopTab(tester, memberships: [
      membership(home, status: MembershipStatus.active, joinedAt: Date(2026, 10, 1)),
    ]);

    expect(find.text('Membre'), findsOneWidget);
    expect(find.text('Membre depuis le 01/10/2026'), findsOneWidget);
    expect(find.text('0,18 €/kWh'), findsOneWidget);
    expect(find.text('9 kWc'), findsOneWidget);
    expect(find.text('0,81 km sur 2 km autorisés'), findsOneWidget);
    expect(find.text('Annuler'), findsNothing);
    expect(find.text('Boucles près de chez vous'), findsNothing);
  });

  testWidgets('entrée future : annonce la date', (tester) async {
    await openLoopTab(tester, memberships: [
      membership(home, status: MembershipStatus.active, joinedAt: Date(2099, 1, 1)),
    ]);

    expect(find.text('Entrée le 01/01/2099'), findsOneWidget);
  });

  testWidgets('demande refusée : l’explique et repropose les boucles', (tester) async {
    await openLoopTab(
      tester,
      available: [availableLoop(id: 'boucle-2', name: 'Henriville', joinable: [home.id])],
      memberships: [membership(home, status: MembershipStatus.rejected)],
    );

    expect(find.text('Demande refusée : Saint-Leu'), findsOneWidget);
    expect(find.text('Henriville'), findsOneWidget);
  });

  testWidgets('les onglets', (tester) async {
    await openLoopTab(tester);

    await goToProfile(tester);
    expect(find.text('Mon profil'), findsOneWidget);
    await tester.tap(find.text('Ma boucle'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Ma boucle'), findsOneWidget);
  });

  group('formats', () {
    test('tarif exact, sans flottant', () {
      expect(formatPrice('0.1800'), '0,18 €/kWh');
      expect(formatPrice('0.1650'), '0,165 €/kWh');
      expect(formatPrice('1'), '1,00 €/kWh');
    });

    test('distances', () {
      expect(formatKm(2), '2 km');
      expect(formatKm(0.814), '0,81 km');
    });
  });
}
