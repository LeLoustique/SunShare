import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_layout.dart';
import '../meters/meters_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
    // Le routeur renvoie vers la connexion dès que l'état passe à « déconnecté »
    if (confirmed == true) await ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Le routeur garantit qu'on n'arrive ici que connecté
    final user = ref.watch(authControllerProvider).value;
    if (user == null) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
        actions: [
          IconButton(
            tooltip: 'État du serveur',
            icon: const Icon(Icons.dns_outlined),
            onPressed: () => context.push('/etat-api'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              '${user.firstName[0]}${user.lastName[0]}'.toUpperCase(),
              style: theme.textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${user.firstName} ${user.lastName}',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.mail_outline),
                  title: const Text('E-mail'),
                  subtitle: Text(user.email),
                ),
                ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('Rôle'),
                  subtitle: Text(roleLabels[user.role] ?? user.role.name),
                ),
                ListTile(
                  leading: const Icon(Icons.event_outlined),
                  title: const Text('Membre depuis le'),
                  subtitle: Text(formatDateTime(user.createdAt)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const MetersSection(),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () => _confirmLogout(context, ref),
            icon: const Icon(Icons.logout),
            label: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}
