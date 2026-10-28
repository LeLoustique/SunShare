import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api.dart';
import '../auth/auth_controller.dart';

class MetersRepository {
  MetersRepository(this._api);

  final SunshareApi _api;

  Future<List<MeterOut>> list() async =>
      (await _api.getCompteursApi().listMeters()).data!.toList();

  /// [address] : libellé choisi parmi [searchAddresses], que le serveur géocode à nouveau.
  Future<MeterOut> create({
    required String prm,
    required MeterDirection direction,
    required String address,
    num? peakKw,
  }) async {
    final response = await _api.getCompteursApi().createMeter(
          meterCreate: MeterCreate((b) => b
            ..prm = prm
            ..direction = direction
            ..address = address
            ..peakKw = peakKw),
        );
    return response.data!;
  }

  Future<void> delete(String id) => _api.getCompteursApi().deleteMeter(meterId: id);

  Future<List<AddressSuggestion>> searchAddresses(String query) async =>
      (await _api.getAdressesApi().searchAddresses(q: query)).data!.toList();
}

final metersRepositoryProvider =
    Provider<MetersRepository>((ref) => MetersRepository(ref.watch(apiProvider)));

/// Compteurs de l'utilisateur connecté ; rechargés quand l'utilisateur change.
final metersProvider = FutureProvider<List<MeterOut>>((ref) {
  ref.watch(authControllerProvider.select((auth) => auth.value?.id));
  return ref.watch(metersRepositoryProvider).list();
});

/// Sens autorisés selon le rôle (même règle que le backend, routers/meters.py).
List<MeterDirection> allowedDirections(UserRole role) => switch (role.name) {
      'producer' => [MeterDirection.production],
      'consumer' => [MeterDirection.consumption],
      _ => [MeterDirection.consumption, MeterDirection.production],
    };

/// « 6,5 kWc » : virgule décimale, sans zéros inutiles.
String formatKw(num kw) {
  final text = kw == kw.roundToDouble() ? kw.toInt().toString() : kw.toString();
  return '${text.replaceAll('.', ',')} kWc';
}
