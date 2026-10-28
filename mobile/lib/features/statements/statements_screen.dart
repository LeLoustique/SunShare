import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api_errors.dart';
import '../../core/format.dart';
import 'statements_repository.dart';

/// Onglet « Factures » : factures (consommation) et reversements (production) émis, mois par mois.
class StatementsScreen extends ConsumerWidget {
  const StatementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statements = ref.watch(myStatementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Factures')),
      body: switch (statements) {
        AsyncData(value: final list) when list.isEmpty => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'Aucune facture pour le moment.\n\nLes factures et relevés sont établis chaque '
                'mois, une fois les données publiées par Enedis, au début du mois suivant.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        AsyncData(value: final list) => RefreshIndicator(
            onRefresh: () => ref.refresh(myStatementsProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [for (final s in list) _StatementTile(statement: s)],
            ),
          ),
        AsyncError(:final error) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(errorMessage(error)),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => ref.invalidate(myStatementsProvider),
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

class _StatementTile extends StatelessWidget {
  const _StatementTile({required this.statement});

  final StatementOut statement;

  @override
  Widget build(BuildContext context) {
    final invoice = isInvoice(statement);
    return Card(
      child: ListTile(
        leading: Icon(invoice ? Icons.receipt_long_outlined : Icons.savings_outlined),
        title: Text('${statementKind(statement.direction)} — ${formatPeriod(statement.period)}'),
        subtitle: Text('N° ${statement.number} · ${statement.loopName}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatEuros(statement.netEur),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(invoice ? 'à payer' : 'reversés', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        onTap: () => context.go('/factures/${statement.id}'),
      ),
    );
  }
}
