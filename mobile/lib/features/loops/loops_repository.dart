import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api.dart';
import '../auth/auth_controller.dart';
import '../meters/meters_repository.dart';

class LoopsRepository {
  LoopsRepository(this._api);

  final SunshareApi _api;

  BouclesApi get _loops => _api.getBouclesApi();

  /// Boucles ouvertes que les compteurs libres de l'utilisateur peuvent rejoindre.
  Future<List<AvailableLoop>> available() async =>
      (await _loops.listAvailableLoops()).data!.toList();

  /// Demandes et participations, tous statuts confondus, les plus récentes d'abord.
  Future<List<MembershipOut>> memberships() async =>
      (await _loops.listMyMemberships()).data!.toList();

  Future<LoopOut> loop(String id) async => (await _loops.readLoop(loopId: id)).data!;

  Future<MembershipOut> join(String loopId, String meterId) async {
    final response = await _loops.joinLoop(
      loopId: loopId,
      joinRequest: JoinRequest((b) => b..meterId = meterId),
    );
    return response.data!;
  }

  Future<void> cancel(String membershipId) =>
      _loops.cancelMembership(membershipId: membershipId);
}

final loopsRepositoryProvider =
    Provider<LoopsRepository>((ref) => LoopsRepository(ref.watch(apiProvider)));

/// Rechargé quand l'utilisateur change.
final membershipsProvider = FutureProvider<List<MembershipOut>>((ref) {
  ref.watch(authControllerProvider.select((auth) => auth.value?.id));
  return ref.watch(loopsRepositoryProvider).memberships();
});

/// Rechargé aussi quand la liste des compteurs change (ajout, suppression).
final availableLoopsProvider = FutureProvider<List<AvailableLoop>>((ref) async {
  await ref.watch(metersProvider.future);
  ref.watch(membershipsProvider);
  return ref.watch(loopsRepositoryProvider).available();
});

final loopDetailProvider = FutureProvider.family<LoopOut, String>(
  (ref, id) => ref.watch(loopsRepositoryProvider).loop(id),
);

bool isEngaged(MembershipOut m) =>
    m.status == MembershipStatus.pending || m.status == MembershipStatus.active;

/// Après une adhésion ou une annulation : tout ce qui en dépend est rechargé.
void refreshLoops(WidgetRef ref) {
  ref.invalidate(membershipsProvider);
  ref.invalidate(loopDetailProvider);
}
