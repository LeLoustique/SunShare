import 'package:test/test.dart';
import 'package:sunshare_api/sunshare_api.dart';


/// tests for CompteursApi
void main() {
  final instance = SunshareApi().getCompteursApi();

  group(CompteursApi, () {
    // Create Meter
    //
    //Future<MeterOut> createMeter(MeterCreate meterCreate) async
    test('test createMeter', () async {
      // TODO
    });

    // Delete Meter
    //
    //Future deleteMeter(String meterId) async
    test('test deleteMeter', () async {
      // TODO
    });

    // List Meters
    //
    // Compteurs de l'utilisateur connecté (jamais ceux des autres).
    //
    //Future<BuiltList<MeterOut>> listMeters() async
    test('test listMeters', () async {
      // TODO
    });

  });
}
