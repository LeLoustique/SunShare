import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Écrans principaux de l'utilisateur connecté, avec la barre de navigation du bas.
/// Chaque onglet garde son état (défilement…) quand on passe à l'autre.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        // Un second appui sur l'onglet actif revient à sa racine
        onDestinationSelected: (index) =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.hub_outlined),
            selectedIcon: Icon(Icons.hub),
            label: 'Ma boucle',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
