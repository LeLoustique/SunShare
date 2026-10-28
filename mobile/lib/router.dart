import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sunshare_api/sunshare_api.dart';

import 'features/auth/auth_controller.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/startup_screen.dart';
import 'features/health/health_screen.dart';
import 'features/home/home_shell.dart';
import 'features/loops/loop_screen.dart';
import 'features/meters/add_meter_screen.dart';
import 'features/profile/profile_screen.dart';

const _guestRoutes = {'/connexion', '/inscription'};

/// Écran d'accueil de l'utilisateur connecté
const homeRoute = '/boucle';

/// Redirige selon l'état de connexion : un visiteur ne voit que la connexion et l'inscription,
/// un utilisateur connecté n'y a plus accès.
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

      final loggedIn = auth.value.value != null;
      if (!loggedIn) return _guestRoutes.contains(location) ? null : '/connexion';
      if (_guestRoutes.contains(location) || location == '/demarrage') return homeRoute;
      return null;
    },
    routes: [
      GoRoute(path: '/demarrage', builder: (_, _) => const StartupScreen()),
      GoRoute(path: '/connexion', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/inscription', builder: (_, _) => const RegisterScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: homeRoute, builder: (_, _) => const LoopScreen()),
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
