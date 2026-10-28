import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sunshare_api/sunshare_api.dart';

import 'features/admin/admin_billing_screen.dart';
import 'features/admin/admin_loop_screen.dart';
import 'features/admin/admin_loops_screen.dart';
import 'features/admin/loop_form_screen.dart';
import 'features/auth/auth_controller.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/startup_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/health/health_screen.dart';
import 'features/home/home_shell.dart';
import 'features/loops/loop_screen.dart';
import 'features/meters/add_meter_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/statements/statement_detail_screen.dart';
import 'features/statements/statements_screen.dart';

const _guestRoutes = {'/connexion', '/inscription'};

/// Écran d'accueil de l'utilisateur connecté : son tableau de bord
const homeRoute = '/accueil';
const loopRoute = '/boucle';
const statementsRoute = '/factures';

/// Écrans réservés aux participants (l'administrateur a le back-office à la place)
const _participantRoutes = [homeRoute, loopRoute, statementsRoute];

/// Écran d'accueil de l'administrateur (back-office)
const adminHomeRoute = '/admin/boucles';

/// Redirige selon l'état de connexion et le rôle : un visiteur ne voit que la connexion et
/// l'inscription ; seul l'administrateur accède à /admin, qui remplace pour lui le tableau de bord
/// et « Ma boucle ».
/// Le serveur refuse de toute façon les routes admin aux autres (403).
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ValueNotifier<AsyncValue<UserOut?>>(ref.read(authControllerProvider));
  ref.listen(authControllerProvider, (_, next) => auth.value = next);
  ref.onDispose(auth.dispose);

  return GoRouter(
    initialLocation: homeRoute,
    refreshListenable: auth,
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (location == '/etat-api') return null;

      // Session en cours de restauration, ou échec réseau au lancement
      if (!auth.value.hasValue) return location == '/demarrage' ? null : '/demarrage';

      final user = auth.value.value;
      if (user == null) return _guestRoutes.contains(location) ? null : '/connexion';

      final isAdmin = user.role == UserRole.admin;
      final home = isAdmin ? adminHomeRoute : homeRoute;
      if (_guestRoutes.contains(location) || location == '/demarrage') return home;
      if (isAdmin && _participantRoutes.any(location.startsWith)) return adminHomeRoute;
      if (!isAdmin && location.startsWith('/admin')) return homeRoute;
      return null;
    },
    routes: [
      GoRoute(path: '/demarrage', builder: (_, _) => const StartupScreen()),
      GoRoute(path: '/connexion', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/inscription', builder: (_, _) => const RegisterScreen()),
      // Branches dans l'ordre des constantes de home_shell.dart (dashboardBranch… profileBranch)
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: homeRoute, builder: (_, _) => const DashboardScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: loopRoute, builder: (_, _) => const LoopScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: statementsRoute,
              builder: (_, _) => const StatementsScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (_, state) =>
                      StatementDetailScreen(statementId: state.pathParameters['id']!),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: adminHomeRoute,
              builder: (_, _) => const AdminLoopsScreen(),
              routes: [
                GoRoute(path: 'nouvelle', builder: (_, _) => const LoopFormScreen()),
                GoRoute(
                  path: ':id',
                  builder: (_, state) => AdminLoopScreen(loopId: state.pathParameters['id']!),
                  routes: [
                    GoRoute(
                      path: 'modifier',
                      builder: (_, state) =>
                          LoopFormScreen(loopId: state.pathParameters['id']),
                    ),
                  ],
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/admin/facturation', builder: (_, _) => const AdminBillingScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profil', builder: (_, _) => const ProfileScreen()),
          ]),
        ],
      ),
      GoRoute(path: '/compteurs/ajout', builder: (_, _) => const AddMeterScreen()),
      GoRoute(path: '/etat-api', builder: (_, _) => const HealthScreen()),
    ],
  );
});
