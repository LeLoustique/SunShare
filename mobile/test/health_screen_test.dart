import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunshare/features/health/health_screen.dart';
import 'package:sunshare_api/sunshare_api.dart';

void main() {
  testWidgets("affiche le statut renvoyé par l'API", (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          healthProvider.overrideWith(
            (ref) async => HealthOut((b) => b
              ..status = 'ok'
              ..extensions.addAll({'postgis': '3.5'})),
          ),
        ],
        child: const MaterialApp(home: HealthScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('API : ok'), findsOneWidget);
    expect(find.text('postgis 3.5'), findsOneWidget);
  });
}
