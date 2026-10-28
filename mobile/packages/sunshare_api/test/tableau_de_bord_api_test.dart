import 'package:test/test.dart';
import 'package:sunshare_api/sunshare_api.dart';


/// tests for TableauDeBordApi
void main() {
  final instance = SunshareApi().getTableauDeBordApi();

  group(TableauDeBordApi, () {
    // Read My Curves
    //
    // Pas de 15 min de la journée : consommation, production et énergie locale de l'utilisateur.
    //
    //Future<DayCurves> readMyCurves({ Date date }) async
    test('test readMyCurves', () async {
      // TODO
    });

    // Read My Dashboard
    //
    // Chiffres du mois : énergie locale, montant estimé, CO2 évité, taux d'autoconsommation.
    //
    //Future<Dashboard> readMyDashboard({ String period }) async
    test('test readMyDashboard', () async {
      // TODO
    });

  });
}
