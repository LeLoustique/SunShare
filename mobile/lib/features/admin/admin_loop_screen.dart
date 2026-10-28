import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api_errors.dart';
import '../../core/format.dart';
import 'admin_repository.dart';

/// Back-office : une boucle, ses demandes d'adhésion et ses membres.
class AdminLoopScreen extends ConsumerWidget {
  const AdminLoopScreen({super.key, required this.loopId});

  final String loopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loop = ref.watch(adminLoopProvider(loopId));
    final members = ref.watch(adminMembersProvider(loopId));

    return Scaffold(
      appBar: AppBar(
        title: Text(loop.value?.name ?? 'Boucle'),
        actions: [
          IconButton(
            tooltip: 'Modifier',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.go('/admin/boucles/$loopId/modifier'),
          ),
        ],
      ),
      body: switch ((loop, members)) {
        (AsyncError(:final error), _) || (_, AsyncError(:final error)) =>
          Center(child: Text(errorMessage(error))),
        (AsyncData(value: null), _) => const Center(child: Text('Boucle introuvable')),
        (AsyncData(value: final AdminLoopOut l), AsyncData(value: final list)) =>
          _Content(loop: l, members: list),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.loop, required this.members});

  final AdminLoopOut loop;
  final List<AdminMemberOut> members;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<AdminMemberOut> withStatus(MembershipStatus s) =>
        members.where((m) => m.status == s).toList();
    final pending = withStatus(MembershipStatus.pending);
    final active = withStatus(MembershipStatus.active);
    final rejected = withStatus(MembershipStatus.rejected);
    final stats = loop.stats;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loop.status == LoopStatus.open
                      ? 'Ouverte aux nouvelles demandes'
                      : 'Fermée aux nouvelles demandes',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text('Tarif ${formatPrice(loop.priceEurKwh)} · '
                    'commission ${formatPrice(loop.commissionEurKwh)}'),
                Text('Clé de répartition : ${allocationModeLabels[loop.allocationMode]}'),
                Text('Étendue ${formatKm(stats.diameterKm)} sur ${formatKm(loop.perimeterKm)} '
                    '(demandes en attente comprises)'),
                Text('${stats.producerCount} producteur(s) · ${stats.consumerCount} consommateur(s) · '
                    '${formatKw(stats.totalPeakKw)} installés'),
                Text('Opération Enedis : ${loop.enedisOperationId ?? 'non renseignée'}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _Section(
          title: 'Demandes en attente (${pending.length})',
          empty: 'Aucune demande en attente',
          children: [for (final m in pending) _MemberTile(member: m, pending: true)],
        ),
        _Section(
          title: 'Membres actifs (${active.length})',
          empty: 'Aucun membre pour le moment',
          children: [for (final m in active) _MemberTile(member: m)],
        ),
        if (rejected.isNotEmpty)
          _Section(
            title: 'Demandes refusées (${rejected.length})',
            children: [for (final m in rejected) _MemberTile(member: m)],
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children, this.empty});

  final String title;
  final List<Widget> children;
  final String? empty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (children.isEmpty && empty != null)
            Card(child: ListTile(title: Text(empty!)))
          else
            ...children,
        ],
      ),
    );
  }
}

class _MemberTile extends ConsumerWidget {
  const _MemberTile({required this.member, this.pending = false});

  final AdminMemberOut member;
  final bool pending;

  void _refresh(WidgetRef ref) {
    ref.invalidate(adminMembersProvider(member.loopId));
    ref.invalidate(adminLoopsProvider);
  }

  Future<void> _run(BuildContext context, WidgetRef ref, Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(e))));
      }
    }
    _refresh(ref);
  }

  Future<void> _approve(BuildContext context, WidgetRef ref) async {
    final joinedAt = await showDialog<Date>(
      context: context,
      builder: (_) => _ApproveDialog(member: member),
    );
    if (joinedAt == null || !context.mounted) return;
    await _run(
      context,
      ref,
      () => ref.read(adminRepositoryProvider).approve(member.loopId, member.id, joinedAt),
    );
  }

  Future<void> _reject(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Refuser la demande ?'),
        content: Text('${member.firstName} ${member.lastName} — PRM ${member.prm}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Refuser')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await _run(
      context,
      ref,
      () => ref.read(adminRepositoryProvider).reject(member.loopId, member.id),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final production = member.direction == MeterDirection.production;
    final joined = member.joinedAt;
    final lines = [
      '${member.email} · PRM ${member.prm}',
      member.address,
      if (production && member.peakKw != null) 'Production · ${formatKw(member.peakKw!)}',
      if (!production) 'Consommation',
      if (pending) 'Demande du ${formatDateTime(member.requestedAt)}',
      if (joined != null) 'Entrée le ${formatDay(joined)}',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: Icon(production ? Icons.solar_power_outlined : Icons.home_outlined),
              title: Text('${member.firstName} ${member.lastName}'),
              subtitle: Text(lines.join('\n')),
              isThreeLine: true,
            ),
            if (pending)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _reject(context, ref),
                      child: const Text('Refuser'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => _approve(context, ref),
                      child: const Text('Valider'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Validation : choix de la date d'entrée dans l'opération (le 1er du mois suivant par défaut).
class _ApproveDialog extends StatefulWidget {
  const _ApproveDialog({required this.member});

  final AdminMemberOut member;

  @override
  State<_ApproveDialog> createState() => _ApproveDialogState();
}

class _ApproveDialogState extends State<_ApproveDialog> {
  late Date _joinedAt = defaultJoinDate(DateTime.now());

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _joinedAt.toDateTime(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _joinedAt = Date(picked.year, picked.month, picked.day));
  }

  @override
  Widget build(BuildContext context) {
    final member = widget.member;
    return AlertDialog(
      title: const Text('Valider l’adhésion'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${member.firstName} ${member.lastName} — PRM ${member.prm}'),
          const SizedBox(height: 16),
          const Text('Date d’entrée dans l’opération'),
          const SizedBox(height: 4),
          Text(formatDay(_joinedAt), style: Theme.of(context).textTheme.titleLarge),
          TextButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_month_outlined),
            label: const Text('Changer la date'),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
        FilledButton(
          onPressed: () => Navigator.pop(context, _joinedAt),
          child: const Text('Valider'),
        ),
      ],
    );
  }
}
