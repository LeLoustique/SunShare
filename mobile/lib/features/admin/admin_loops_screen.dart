import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api_errors.dart';
import '../../core/format.dart';
import 'admin_repository.dart';

/// Back-office : liste des boucles de la PMO.
class AdminLoopsScreen extends ConsumerWidget {
  const AdminLoopsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loops = ref.watch(adminLoopsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Boucles')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/admin/boucles/nouvelle'),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle boucle'),
      ),
      body: switch (loops) {
        AsyncData(value: final list) when list.isEmpty => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'Aucune boucle pour le moment.\nCréez la première avec « Nouvelle boucle ».',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        AsyncData(value: final list) => RefreshIndicator(
            onRefresh: () => ref.refresh(adminLoopsProvider.future),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [for (final loop in list) _LoopTile(loop: loop)],
            ),
          ),
        AsyncError(:final error) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(errorMessage(error)),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => ref.invalidate(adminLoopsProvider),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _LoopTile extends StatelessWidget {
  const _LoopTile({required this.loop});

  final AdminLoopOut loop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final open = loop.status == LoopStatus.open;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/admin/boucles/${loop.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(loop.name, style: theme.textTheme.titleMedium)),
                  if (loop.pendingCount > 0) ...[
                    Badge(
                      label: Text('${loop.pendingCount}'),
                      child: const Icon(Icons.how_to_reg_outlined),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Chip(label: Text(open ? 'Ouverte' : 'Fermée')),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${loop.stats.memberCount} membre${loop.stats.memberCount > 1 ? 's' : ''}'
                '${loop.pendingCount > 0 ? ' · ${loop.pendingCount} demande${loop.pendingCount > 1 ? 's' : ''} en attente' : ''}',
              ),
              Text(
                'Tarif ${formatPrice(loop.priceEurKwh)} · commission ${formatPrice(loop.commissionEurKwh)}',
              ),
              Text(
                'Étendue ${formatKm(loop.stats.diameterKm)} sur ${formatKm(loop.perimeterKm)}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
