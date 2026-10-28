import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api.dart';

/// Routes /admin/loops : réservées au rôle admin (PMO), le serveur le vérifie à chaque appel.
class AdminRepository {
  AdminRepository(this._api);

  final SunshareApi _api;

  AdminApi get _admin => _api.getAdminApi();

  Future<List<AdminLoopOut>> loops() async => (await _admin.adminListLoops()).data!.toList();

  Future<AdminLoopOut> create(LoopCreate loop) async =>
      (await _admin.adminCreateLoop(loopCreate: loop)).data!;

  /// Seuls les champs renseignés de [changes] sont envoyés.
  Future<AdminLoopOut> update(String loopId, LoopUpdate changes) async =>
      (await _admin.adminUpdateLoop(loopId: loopId, loopUpdate: changes)).data!;

  Future<List<AdminMemberOut>> members(String loopId) async =>
      (await _admin.adminListMembers(loopId: loopId)).data!.toList();

  Future<AdminMemberOut> approve(String loopId, String memberId, Date joinedAt) async {
    final response = await _admin.adminApproveMember(
      loopId: loopId,
      memberId: memberId,
      approveRequest: ApproveRequest((b) => b..joinedAt = joinedAt),
    );
    return response.data!;
  }

  Future<AdminMemberOut> reject(String loopId, String memberId) async =>
      (await _admin.adminRejectMember(loopId: loopId, memberId: memberId)).data!;

  /// Calcule (ou recalcule) les brouillons du mois, sur les seules énergies Enedis.
  Future<BillingRunOut> runBilling(String month) async =>
      (await _admin.adminRunBilling(month: month)).data!;

  /// Émet les brouillons du mois : numérotés, figés, visibles des participants.
  Future<IssueOut> issueStatements(String month) async =>
      (await _admin.adminIssueStatements(month: month)).data!;

  Future<List<AdminStatementOut>> statements(String month) async =>
      (await _admin.adminListStatements(month: month)).data!.toList();
}

final adminRepositoryProvider =
    Provider<AdminRepository>((ref) => AdminRepository(ref.watch(apiProvider)));

final adminLoopsProvider = FutureProvider<List<AdminLoopOut>>(
  (ref) => ref.watch(adminRepositoryProvider).loops(),
);

/// Pas de route « une boucle » côté admin : on la prend dans la liste.
final adminLoopProvider = FutureProvider.family<AdminLoopOut?, String>((ref, id) async {
  final loops = await ref.watch(adminLoopsProvider.future);
  return loops.where((loop) => loop.id == id).firstOrNull;
});

final adminMembersProvider = FutureProvider.family<List<AdminMemberOut>, String>(
  (ref, loopId) => ref.watch(adminRepositoryProvider).members(loopId),
);

final allocationModeLabels = <AllocationMode, String>{
  AllocationMode.dynamicDefault: 'Dynamique (au prorata des consommations)',
  AllocationMode.static_: 'Statique (coefficients fixes)',
  AllocationMode.dynamicCustom: 'Dynamique personnalisée',
};

/// Date d'entrée proposée par défaut : le 1er du mois suivant.
Date defaultJoinDate(DateTime now) =>
    now.month == 12 ? Date(now.year + 1, 1, 1) : Date(now.year, now.month + 1, 1);

final adminStatementsProvider = FutureProvider.family<List<AdminStatementOut>, String>(
  (ref, month) => ref.watch(adminRepositoryProvider).statements(month),
);

/// Mois facturé par défaut : le précédent (Enedis publie en M+1).
({int year, int month}) defaultBillingMonth(DateTime now) {
  final previous = DateTime(now.year, now.month - 1);
  return (year: previous.year, month: previous.month);
}
