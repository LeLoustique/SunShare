import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api_errors.dart';
import '../../core/format.dart';
import '../meters/meters_repository.dart';
import 'loops_repository.dart';

/// Onglet « Ma boucle » : participation en cours, ou boucles que l'utilisateur peut rejoindre.
class LoopScreen extends ConsumerWidget {
  const LoopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meters = ref.watch(metersProvider);
    final memberships = ref.watch(membershipsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ma boucle')),
      body: switch ((meters, memberships)) {
        (AsyncError(:final error), _) || (_, AsyncError(:final error)) => _ErrorView(
            message: errorMessage(error),
            onRetry: () {
              ref.invalidate(metersProvider);
              ref.invalidate(membershipsProvider);
            },
          ),
        (AsyncData(value: final meterList), AsyncData(value: final membershipList)) =>
          RefreshIndicator(
            onRefresh: () async {
              refreshLoops(ref);
              await ref.read(membershipsProvider.future);
            },
            child: _content(meterList, membershipList),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _content(List<MeterOut> meters, List<MembershipOut> memberships) {
    if (meters.isEmpty) return const _NoMeter();

    final engaged = memberships.where(isEngaged).toList();
    final engagedMeterIds = engaged.map((m) => m.meterId).toSet();
    final hasFreeMeter = meters.any((m) => !engagedMeterIds.contains(m.id));
    // Dernier refus d'un compteur redevenu libre : on l'explique au-dessus des boucles disponibles
    final rejected = memberships
        .where((m) => m.status == MembershipStatus.rejected && !engagedMeterIds.contains(m.meterId))
        .toList();

    final byLoop = <String, List<MembershipOut>>{};
    for (final membership in engaged) {
      byLoop.putIfAbsent(membership.loopId, () => []).add(membership);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final entry in byLoop.entries) ...[
          _MyLoopCard(loopId: entry.key, memberships: entry.value),
          const SizedBox(height: 16),
        ],
        if (hasFreeMeter) ...[
          if (rejected.isNotEmpty) ...[
            Card(
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text('Demande refusée : ${rejected.first.loopName}'),
                subtitle: const Text("L'organisateur n'a pas validé votre demande."),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _AvailableLoops(meters: meters, title: byLoop.isEmpty ? null : 'Vos autres compteurs'),
        ],
      ],
    );
  }
}

class _NoMeter extends StatelessWidget {
  const _NoMeter();

  @override
  Widget build(BuildContext context) {
    return _Message(
      icon: Icons.electric_meter_outlined,
      title: 'Ajoutez votre compteur',
      text: 'Pour rejoindre une boucle de quartier, enregistrez d’abord votre compteur Linky '
          '(numéro PRM et adresse).',
      action: FilledButton.icon(
        onPressed: () => context.push('/compteurs/ajout'),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter un compteur'),
      ),
    );
  }
}

/// Boucle dans laquelle l'utilisateur a une demande en cours ou participe.
class _MyLoopCard extends ConsumerWidget {
  const _MyLoopCard({required this.loopId, required this.memberships});

  final String loopId;
  final List<MembershipOut> memberships;

  Future<void> _cancel(BuildContext context, WidgetRef ref, MembershipOut membership) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la demande ?'),
        content: Text('Compteur PRM ${membership.prm} — ${membership.loopName}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Non')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Annuler la demande'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(loopsRepositoryProvider).cancel(membership.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(e))));
      }
    }
    refreshLoops(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final detail = ref.watch(loopDetailProvider(loopId));
    final active = memberships.any((m) => m.status == MembershipStatus.active);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(memberships.first.loopName, style: theme.textTheme.titleLarge),
                ),
                Chip(
                  avatar: Icon(active ? Icons.check_circle : Icons.hourglass_top, size: 18),
                  label: Text(active ? 'Membre' : 'En attente'),
                ),
              ],
            ),
            if (!active) ...[
              const SizedBox(height: 8),
              const Text(
                'L’organisateur de la boucle doit valider votre demande et fixer votre date '
                'd’entrée dans l’opération.',
              ),
            ],
            const SizedBox(height: 8),
            switch (detail) {
              AsyncData(value: final loop) => _LoopFacts(loop: loop),
              AsyncError(:final error) => Text(errorMessage(error)),
              _ => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            },
            const Divider(height: 24),
            Text('Mes compteurs', style: theme.textTheme.titleSmall),
            for (final membership in memberships)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(membership.direction == MeterDirection.production
                    ? Icons.solar_power_outlined
                    : Icons.home_outlined),
                title: Text('PRM ${membership.prm}'),
                subtitle: Text(_membershipStatus(membership)),
                trailing: membership.status == MembershipStatus.pending
                    ? TextButton(
                        onPressed: () => _cancel(context, ref, membership),
                        child: const Text('Annuler'),
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  String _membershipStatus(MembershipOut m) {
    if (m.status == MembershipStatus.pending) {
      return 'Demande envoyée le ${formatDateTime(m.requestedAt)}';
    }
    final joined = m.joinedAt;
    if (joined == null) return 'Membre';
    final started = !joined.toDateTime().isAfter(DateTime.now());
    return started ? 'Membre depuis le ${formatDay(joined)}' : 'Entrée le ${formatDay(joined)}';
  }
}

/// Chiffres agrégés de la boucle : jamais d'information sur un autre membre.
class _LoopFacts extends StatelessWidget {
  const _LoopFacts({required this.loop});

  final LoopOut loop;

  @override
  Widget build(BuildContext context) {
    final stats = loop.stats;
    return Column(
      children: [
        _Fact(Icons.euro, 'Tarif', formatPrice(loop.priceEurKwh)),
        _Fact(
          Icons.groups_outlined,
          'Participants',
          '${stats.memberCount} (${stats.producerCount} producteur${stats.producerCount > 1 ? 's' : ''}, '
              '${stats.consumerCount} consommateur${stats.consumerCount > 1 ? 's' : ''})',
        ),
        if (stats.totalPeakKw > 0)
          _Fact(Icons.solar_power_outlined, 'Puissance installée', formatKw(stats.totalPeakKw)),
        _Fact(
          Icons.straighten,
          'Étendue',
          '${formatKm(stats.diameterKm)} sur ${formatKm(loop.perimeterKm)} autorisés',
        ),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          SizedBox(width: 130, child: Text(label)),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

/// Boucles que les compteurs libres de l'utilisateur peuvent rejoindre.
class _AvailableLoops extends ConsumerWidget {
  const _AvailableLoops({required this.meters, this.title});

  final List<MeterOut> meters;
  final String? title;

  Future<void> _join(BuildContext context, WidgetRef ref, AvailableLoop loop) async {
    final joining = meters.where((m) => loop.joinableMeterIds.contains(m.id)).toList();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rejoindre « ${loop.name} » ?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tarif de l’énergie partagée : ${formatPrice(loop.priceEurKwh)}'),
            const SizedBox(height: 8),
            Text(joining.length > 1 ? 'Compteurs concernés :' : 'Compteur concerné :'),
            for (final meter in joining) Text('• PRM ${meter.prm}'),
            const SizedBox(height: 8),
            const Text('Votre demande sera examinée par l’organisateur de la boucle.'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Envoyer la demande'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final repository = ref.read(loopsRepositoryProvider);
    try {
      for (final meter in joining) {
        await repository.join(loop.id, meter.id);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demande envoyée')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(e))));
      }
    }
    refreshLoops(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final available = ref.watch(availableLoopsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title ?? 'Boucles près de chez vous', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        switch (available) {
          AsyncData(value: final loops) when loops.isEmpty => const Card(
              child: ListTile(
                leading: Icon(Icons.location_off_outlined),
                title: Text('Aucune boucle ne couvre encore votre adresse'),
                subtitle: Text(
                  'Une boucle réunit des voisins dont les sites les plus éloignés sont à moins '
                  'de 2 km. Revenez plus tard : de nouvelles boucles ouvrent régulièrement.',
                ),
              ),
            ),
          AsyncData(value: final loops) => Column(
              children: [
                for (final loop in loops)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(loop.name, style: theme.textTheme.titleMedium),
                          const SizedBox(height: 8),
                          _Fact(Icons.euro, 'Tarif', formatPrice(loop.priceEurKwh)),
                          _Fact(Icons.groups_outlined, 'Participants', '${loop.memberCount}'),
                          _Fact(Icons.straighten, 'Périmètre', formatKm(loop.perimeterKm)),
                          const SizedBox(height: 8),
                          FilledButton(
                            onPressed: () => _join(context, ref, loop),
                            child: const Text('Demander à rejoindre'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          AsyncError(:final error) => _ErrorView(
              message: errorMessage(error),
              onRetry: () => ref.invalidate(availableLoopsProvider),
            ),
          _ => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
        },
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.title, required this.text, this.action});

  final IconData icon;
  final String title;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(title, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(text, textAlign: TextAlign.center),
              if (action != null) ...[const SizedBox(height: 24), action!],
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 40, color: Colors.red),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          FilledButton(onPressed: onRetry, child: const Text('Réessayer')),
        ],
      ),
    );
  }
}
