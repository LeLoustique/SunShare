import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunshare/features/meters/add_meter_screen.dart';
import 'package:sunshare/features/meters/meters_repository.dart';
import 'package:sunshare_api/sunshare_api.dart';

import 'helpers.dart';

Finder field(String label) => find.widgetWithText(TextFormField, label);

Future<FakeMetersRepository> openAddMeter(
  WidgetTester tester, {
  UserRole? role,
  List<MeterOut>? meters,
}) async {
  final repository = FakeMetersRepository(meters);
  await pumpApp(tester, auth: FakeAuthRepository(loggedIn: true, role: role), meters: repository);
  await tester.tap(find.text('Ajouter un compteur'));
  await tester.pumpAndSettle();
  return repository;
}

/// Tape le début de l'adresse, attend les suggestions puis choisit la première.
Future<void> chooseAddress(WidgetTester tester) async {
  await tester.enterText(field('Adresse du compteur'), '8 bd du port');
  await tester.pump(addressDebounce);
  await tester.pumpAndSettle();
  await tester.tap(find.text(amiens.label).last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('profil sans compteur : invite à en ajouter un', (tester) async {
    await pumpApp(tester, auth: FakeAuthRepository(loggedIn: true));

    expect(find.text('Aucun compteur pour le moment'), findsOneWidget);
    expect(find.text('Ajouter un compteur'), findsOneWidget);
  });

  testWidgets('profil : liste les compteurs', (tester) async {
    await pumpApp(
      tester,
      auth: FakeAuthRepository(loggedIn: true),
      meters: FakeMetersRepository([
        meter(prm: '12345678901234', direction: MeterDirection.production, peakKw: 6.5),
      ]),
    );

    expect(find.text('Production · 6,5 kWc'), findsOneWidget);
    expect(find.textContaining('PRM 12345678901234'), findsOneWidget);
  });

  testWidgets('producteur : ajoute un compteur de production', (tester) async {
    final repository = await openAddMeter(tester, role: UserRole.producer);

    // Un producteur n'a pas le choix du type de compteur
    expect(find.text('Compteur de production (panneaux solaires)'), findsOneWidget);
    expect(find.text('Consommation'), findsNothing);

    await tester.enterText(field('Numéro PRM'), '12345678901234');
    await chooseAddress(tester);
    await tester.enterText(field('Puissance crête (kWc)'), '6,5');
    await tester.tap(find.text('Ajouter le compteur'));
    await tester.pumpAndSettle();

    final created = repository.meters.single;
    expect(created.direction, MeterDirection.production);
    expect(created.address, amiens.label);
    expect(created.peakKw, 6.5);
    // Retour au profil, qui affiche le nouveau compteur
    expect(find.text('Mon profil'), findsOneWidget);
    expect(find.text('Production · 6,5 kWc'), findsOneWidget);
  });

  testWidgets('consommateur : pas de puissance crête demandée', (tester) async {
    final repository = await openAddMeter(tester, role: UserRole.consumer);

    expect(find.text('Compteur de consommation'), findsOneWidget);
    expect(field('Puissance crête (kWc)'), findsNothing);

    await tester.enterText(field('Numéro PRM'), '12345678901234');
    await chooseAddress(tester);
    await tester.tap(find.text('Ajouter le compteur'));
    await tester.pumpAndSettle();

    expect(repository.meters.single.direction, MeterDirection.consumption);
    expect(repository.meters.single.peakKw, isNull);
  });

  testWidgets('mixte : choisit le type de compteur', (tester) async {
    await openAddMeter(tester, role: UserRole.mixed);

    expect(field('Puissance crête (kWc)'), findsNothing);
    await tester.tap(find.text('Production'));
    await tester.pumpAndSettle();
    expect(field('Puissance crête (kWc)'), findsOneWidget);
  });

  testWidgets('valide le PRM, l’adresse et la puissance', (tester) async {
    final repository = await openAddMeter(tester, role: UserRole.producer);

    await tester.enterText(field('Numéro PRM'), '12345abc');
    await tester.enterText(field('Adresse du compteur'), 'adresse tapée à la main');
    await tester.enterText(field('Puissance crête (kWc)'), '6,555');
    await tester.tap(find.text('Ajouter le compteur'));
    await tester.pumpAndSettle();

    // Les lettres sont filtrées à la saisie : il reste « 12345 »
    expect(find.text('Le PRM compte 14 chiffres'), findsOneWidget);
    expect(find.text('Choisissez une adresse dans la liste'), findsOneWidget);
    expect(find.text('2 décimales au plus'), findsOneWidget);
    expect(repository.meters, isEmpty);
  });

  testWidgets('adresse modifiée après le choix : refusée', (tester) async {
    await openAddMeter(tester, role: UserRole.consumer);

    await tester.enterText(field('Numéro PRM'), '12345678901234');
    await chooseAddress(tester);
    // Retouchée à la main : plus de suggestion correspondante, donc plus d'adresse géocodée
    await tester.enterText(field('Adresse du compteur'), '8 Boulevard du Pont 80000 Amiens');
    await tester.pump(addressDebounce);
    await tester.tap(find.text('Ajouter le compteur'));
    await tester.pumpAndSettle();

    expect(find.text('Choisissez une adresse dans la liste'), findsOneWidget);
  });

  testWidgets('PRM déjà enregistré : affiche le message de l’API', (tester) async {
    await openAddMeter(
      tester,
      role: UserRole.consumer,
      meters: [meter(prm: '12345678901234')],
    );

    await tester.enterText(field('Numéro PRM'), '12345678901234');
    await chooseAddress(tester);
    await tester.tap(find.text('Ajouter le compteur'));
    await tester.pumpAndSettle();

    expect(find.text('Ce compteur est déjà enregistré'), findsOneWidget);
  });

  testWidgets('suppression après confirmation', (tester) async {
    final repository = FakeMetersRepository([meter(prm: '12345678901234')]);
    await pumpApp(tester, auth: FakeAuthRepository(loggedIn: true), meters: repository);

    await tester.tap(find.byTooltip('Supprimer'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Supprimer'));
    await tester.pumpAndSettle();

    expect(repository.meters, isEmpty);
    expect(find.text('Aucun compteur pour le moment'), findsOneWidget);
  });

  test('formatKw', () {
    expect(formatKw(6), '6 kWc');
    expect(formatKw(6.5), '6,5 kWc');
    expect(formatKw(12.25), '12,25 kWc');
  });
}
