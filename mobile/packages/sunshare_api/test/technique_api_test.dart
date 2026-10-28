import 'package:test/test.dart';
import 'package:sunshare_api/sunshare_api.dart';


/// tests for TechniqueApi
void main() {
  final instance = SunshareApi().getTechniqueApi();

  group(TechniqueApi, () {
    // Health
    //
    // Vérifie que l'API joint la base et que les extensions sont actives.
    //
    //Future<HealthOut> health() async
    test('test health', () async {
      // TODO
    });

  });
}
