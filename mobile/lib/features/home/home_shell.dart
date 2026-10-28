import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../auth/auth_controller.dart';

/// Branches du StatefulShellRoute (voir router.dart), dans l'ordre de déclaration.
const loopBranch = 0;
const adminBranch = 1;
const profileBranch = 2;

/// Écrans principaux de l'utilisateur connecté, avec la barre de navigation du bas.
/// Chaque onglet garde son état (défilement…) quand on passe à l'autre. L'administrateur a
/// l'onglet « Boucles » (back-office) à la place de « Ma boucle ».
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(authControllerProvider).value?.role == UserRole.admin;
    final branches = [isAdmin ? adminBranch : loopBranch, profileBranch];
    final selected = branches.indexOf(shell.currentIndex);

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected < 0 ? 0 : selected,
        // Un second appui sur l'onglet actif revient à sa racine
        onDestinationSelected: (index) => shell.goBranch(
          branches[index],
          initialLocation: branches[index] == shell.currentIndex,
        ),
        destinations: [
          if (isAdmin)
            const NavigationDestination(
              icon: Icon(Icons.admin_panel_settings_outlined),
              selectedIcon: Icon(Icons.admin_panel_settings),
              label: 'Boucles',
            )
          else
            const NavigationDestination(
              icon: Icon(Icons.hub_outlined),
              selectedIcon: Icon(Icons.hub),
              label: 'Ma boucle',
            ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
