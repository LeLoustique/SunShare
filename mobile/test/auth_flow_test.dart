import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunshare_api/sunshare_api.dart';

import 'helpers.dart';

Future<FakeAuthRepository> startApp(WidgetTester tester, {bool loggedIn = false}) async {
  final repository = FakeAuthRepository(loggedIn: loggedIn);
  await pumpApp(tester, auth: repository);
  return repository;
}

Finder field(String label) => find.widgetWithText(TextFormField, label);

void main() {
  testWidgets('sans session, affiche la connexion', (tester) async {
    await startApp(tester);

    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Mon profil'), findsNothing);
  });

  testWidgets('avec une session enregistrée, ouvre directement l’accueil', (tester) async {
    await startApp(tester, loggedIn: true);
    expect(find.widgetWithText(AppBar, 'Ma boucle'), findsOneWidget);

    await goToProfile(tester);
    expect(find.text('Mon profil'), findsOneWidget);
    expect(find.text('Camille Martin'), findsOneWidget);
    expect(find.text('Producteur'), findsOneWidget);
    expect(find.text('28/10/2026'), findsOneWidget);
  });

  testWidgets('connexion réussie : bascule vers l’accueil', (tester) async {
    await startApp(tester);

    await tester.enterText(field('E-mail'), 'camille@exemple.fr');
    await tester.enterText(field('Mot de passe'), validPassword);
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Ma boucle'), findsOneWidget);
    await goToProfile(tester);
    expect(find.text('camille@exemple.fr'), findsOneWidget);
  });

  testWidgets("mauvais mot de passe : affiche le message de l'API", (tester) async {
    await startApp(tester);

    await tester.enterText(field('E-mail'), 'camille@exemple.fr');
    await tester.enterText(field('Mot de passe'), 'pas-le-bon');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('E-mail ou mot de passe incorrect'), findsOneWidget);
    expect(find.text('Connexion'), findsOneWidget);
  });

  testWidgets('connexion : champs vides refusés sans appel à l’API', (tester) async {
    final repository = await startApp(tester);

    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Saisissez votre e-mail'), findsOneWidget);
    expect(find.text('Saisissez votre mot de passe'), findsOneWidget);
    expect(repository.loggedIn, isFalse);
  });

  testWidgets('inscription : valide le formulaire', (tester) async {
    final repository = await startApp(tester);
    await tester.tap(find.text('Pas encore de compte ? Créer un compte'));
    await tester.pumpAndSettle();

    await tester.enterText(field('E-mail'), 'pas-un-email');
    await tester.enterText(field('Mot de passe'), 'court');
    await tester.enterText(field('Confirmer le mot de passe'), 'autre');
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(find.text('Saisissez votre prénom'), findsOneWidget);
    expect(find.text('E-mail invalide'), findsOneWidget);
    expect(find.text('Au moins 10 caractères'), findsOneWidget);
    expect(find.text('Les mots de passe ne correspondent pas'), findsOneWidget);
    expect(repository.registered, isNull);
  });

  testWidgets('inscription réussie : connecte l’utilisateur', (tester) async {
    final repository = await startApp(tester);
    await tester.tap(find.text('Pas encore de compte ? Créer un compte'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Les deux'));
    await tester.enterText(field('Prénom'), 'Alex');
    await tester.enterText(field('Nom'), 'Durand');
    await tester.enterText(field('E-mail'), 'alex@exemple.fr');
    await tester.enterText(field('Mot de passe'), validPassword);
    await tester.enterText(field('Confirmer le mot de passe'), validPassword);
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(repository.registered!.role, UserRole.mixed);
    await goToProfile(tester);
    expect(find.text('Alex Durand'), findsOneWidget);
    expect(find.text('Producteur et consommateur'), findsOneWidget);
  });

  testWidgets('inscription avec un e-mail déjà pris : affiche le message', (tester) async {
    await startApp(tester);
    await tester.tap(find.text('Pas encore de compte ? Créer un compte'));
    await tester.pumpAndSettle();

    await tester.enterText(field('Prénom'), 'Camille');
    await tester.enterText(field('Nom'), 'Martin');
    await tester.enterText(field('E-mail'), 'camille@exemple.fr');
    await tester.enterText(field('Mot de passe'), validPassword);
    await tester.enterText(field('Confirmer le mot de passe'), validPassword);
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(find.text('Un compte existe déjà avec cet e-mail'), findsOneWidget);
  });

  testWidgets('déconnexion après confirmation : retour à la connexion', (tester) async {
    final repository = await startApp(tester, loggedIn: true);
    await goToProfile(tester);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Se déconnecter'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Se déconnecter'));
    await tester.pumpAndSettle();

    expect(repository.loggedIn, isFalse);
    expect(find.text('Connexion'), findsOneWidget);
  });
}
