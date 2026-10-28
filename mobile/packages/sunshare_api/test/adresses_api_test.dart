import 'package:test/test.dart';
import 'package:sunshare_api/sunshare_api.dart';


/// tests for AdressesApi
void main() {
  final instance = SunshareApi().getAdressesApi();

  group(AdressesApi, () {
    // Search Addresses
    //
    // Suggestions d'adresses précises (numéro ou lieu-dit) pendant la saisie.
    //
    //Future<BuiltList<AddressSuggestion>> searchAddresses(String q) async
    test('test searchAddresses', () async {
      // TODO
    });

  });
}
