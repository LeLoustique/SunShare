import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../auth/auth_controller.dart';

/// Branches du StatefulShellRoute (voir router.dart), dans l'ordre de déclaration.
const dashboardBranch = 0;
const loopBranch = 1;
const statementsBranch = 2;
const adminBranch = 3;
const adminBillingBranch = 4;
const profileBranch = 5;

/// Écrans principaux de l'utilisateur connecté, avec la barre de navigation du bas.
/// Chaque onglet garde son état (défilement…) quand on passe à l'autre. L'administrateur a
/// les onglets du back-office (« Boucles », « Facturation ») à la place de ceux des participants.
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(authControllerProvider).value?.role == UserRole.admin;
    final branches = isAdmin
        ? [adminBranch, adminBillingBranch, profileBranch]
        : [dashboardBranch, loopBranch, statementsBranch, profileBranch];
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
          if (isAdmin) ...const [
            NavigationDestination(
              icon: Icon(Icons.admin_panel_settings_outlined),
              selectedIcon: Icon(Icons.admin_panel_settings),
              label: 'Boucles',
            ),
            NavigationDestination(
              icon: Icon(Icons.request_quote_outlined),
              selectedIcon: Icon(Icons.request_quote),
              label: 'Facturation',
            ),
          ] else ...const [
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights),
              label: 'Tableau de bord',
            ),
            NavigationDestination(
              icon: Icon(Icons.hub_outlined),
              selectedIcon: Icon(Icons.hub),
              label: 'Ma boucle',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Factures',
            ),
          ],
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
