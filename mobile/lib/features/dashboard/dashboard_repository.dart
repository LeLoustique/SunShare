import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api.dart';
import '../auth/auth_controller.dart';

class DashboardRepository {
  DashboardRepository(this._api);

  final SunshareApi _api;

  TableauDeBordApi get _dashboard => _api.getTableauDeBordApi();

  /// Chiffres d'un mois (« 2026-10 »).
  Future<Dashboard> month(String period) async =>
      (await _dashboard.readMyDashboard(period: period)).data!;

  /// Pas de 15 min d'une journée française.
  Future<DayCurves> day(Date day) async => (await _dashboard.readMyCurves(date: day)).data!;
}

final dashboardRepositoryProvider =
    Provider<DashboardRepository>((ref) => DashboardRepository(ref.watch(apiProvider)));

/// Rechargés quand l'utilisateur change.
final monthDashboardProvider = FutureProvider.family<Dashboard, String>((ref, period) {
  ref.watch(authControllerProvider.select((auth) => auth.value?.id));
  return ref.watch(dashboardRepositoryProvider).month(period);
});

final dayCurvesProvider = FutureProvider.family<DayCurves, Date>((ref, day) {
  ref.watch(authControllerProvider.select((auth) => auth.value?.id));
  return ref.watch(dashboardRepositoryProvider).day(day);
});

/// Les mesures arrivent en J+1 : la veille est le jour le plus récent consultable.
Date latestDay(DateTime now) => now.subtract(const Duration(days: 1)).toDate();
