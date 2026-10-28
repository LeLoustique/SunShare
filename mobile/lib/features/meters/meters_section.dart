import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api_errors.dart';
import '../../core/format.dart';
import 'meters_repository.dart';

/// « Mes compteurs », affiché dans le profil.
class MetersSection extends ConsumerWidget {
  const MetersSection({super.key});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, MeterOut meter) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce compteur ?'),
        content: Text('PRM ${meter.prm}\n${meter.address}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(metersRepositoryProvider).delete(meter.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(e))));
      }
    }
    ref.invalidate(metersProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meters = ref.watch(metersProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Mes compteurs', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: meters.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => ListTile(
              leading: const Icon(Icons.error_outline, color: Colors.red),
              title: Text(errorMessage(error)),
              trailing: TextButton(
                onPressed: () => ref.invalidate(metersProvider),
                child: const Text('Réessayer'),
              ),
            ),
            data: (list) => list.isEmpty
                ? const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Aucun compteur pour le moment'),
                    subtitle: Text('Ajoutez votre compteur Linky pour rejoindre une boucle.'),
                  )
                : Column(
                    children: [
                      for (final meter in list)
                        ListTile(
                          leading: Icon(meter.direction == MeterDirection.production
                              ? Icons.solar_power_outlined
                              : Icons.home_outlined),
                          title: Text(meter.direction == MeterDirection.production
                              ? 'Production · ${formatKw(meter.peakKw ?? 0)}'
                              : 'Consommation'),
                          subtitle: Text('${meter.address}\nPRM ${meter.prm}'),
                          isThreeLine: true,
                          trailing: IconButton(
                            tooltip: 'Supprimer',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _confirmDelete(context, ref, meter),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.tonalIcon(
          onPressed: () => context.push('/compteurs/ajout'),
          icon: const Icon(Icons.add),
          label: const Text('Ajouter un compteur'),
        ),
      ],
    );
  }
}
