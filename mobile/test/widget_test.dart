import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunshare/main.dart';

void main() {
  testWidgets("affiche le statut renvoyé par l'API", (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          healthProvider.overrideWith(
            (ref) async => {'status': 'ok', 'extensions': {'postgis': '3.5'}},
          ),
        ],
        child: const SunShareApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('API : ok'), findsOneWidget);
    expect(find.text('postgis 3.5'), findsOneWidget);
  });
}
