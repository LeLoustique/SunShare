import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api_errors.dart';
import '../../core/format.dart';
import '../statements/statement_detail_screen.dart';
import '../statements/statements_repository.dart';
import 'admin_repository.dart';

/// Back-office : facturation d'un mois. Calculer les brouillons (sur les énergies Enedis),
/// les vérifier un par un (PDF « BROUILLON »), puis les émettre — irréversible.
class AdminBillingScreen extends ConsumerStatefulWidget {
  const AdminBillingScreen({super.key});

  @override
  ConsumerState<AdminBillingScreen> createState() => _AdminBillingScreenState();
}

class _AdminBillingScreenState extends ConsumerState<AdminBillingScreen> {
  late final _latest = defaultBillingMonth(DateTime.now());
  late int _year = _latest.year;
  late int _month = _latest.month;
  BillingRunOut? _report;
  bool _busy = false;

  String get _period => periodOf(_year, _month);

  void _shiftMonth(int delta) => setState(() {
        final shifted = DateTime(_year, _month + delta);
        _year = shifted.year;
        _month = shifted.month;
        _report = null;
      });

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(e))));
      }
    } finally {
      ref.invalidate(adminStatementsProvider(_period));
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _computeDrafts() => _run(() async {
        final report = await ref.read(adminRepositoryProvider).runBilling(_period);
        if (mounted) setState(() => _report = report);
      });

  Future<void> _issue(int drafts) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Émettre $drafts relevé${drafts > 1 ? 's' : ''} ?'),
        content: Text(
          'Les relevés de ${formatPeriod(_period)} recevront un numéro définitif et deviendront '
          'visibles des participants. Ils ne pourront plus être modifiés : une erreur se corrigera '
          'par un avoir.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Émettre')),
        ],
      ),
    );
    if (confirmed != true) return;
    await _run(() async {
      final issued = await ref.read(adminRepositoryProvider).issueStatements(_period);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${issued.issued} relevé(s) émis : ${issued.firstNumber} à ${issued.lastNumber}'),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statements = ref.watch(adminStatementsProvider(_period));
    final list = statements.value ?? const <AdminStatementOut>[];
    final drafts = list.where((s) => s.status == StatementStatus.draft).length;
    final latest = _year == _latest.year && _month == _latest.month;

    return Scaffold(
      appBar: AppBar(title: const Text('Facturation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Mois précédent',
                onPressed: () => _shiftMonth(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  formatPeriod(_period),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Mois suivant',
                onPressed: latest ? null : () => _shiftMonth(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: _busy ? null : _computeDrafts,
                icon: const Icon(Icons.calculate_outlined),
                label: const Text('Calculer les brouillons'),
              ),
              FilledButton.icon(
                onPressed: _busy || drafts == 0 ? null : () => _issue(drafts),
                icon: const Icon(Icons.verified_outlined),
                label: Text('Émettre $drafts brouillon${drafts > 1 ? 's' : ''}'),
              ),
            ],
          ),
          if (_report != null) _RunReport(report: _report!),
          const SizedBox(height: 16),
          switch (statements) {
            AsyncData(value: final list) when list.isEmpty => const Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Aucun relevé pour ce mois'),
                  subtitle: Text(
                    'Calculez les brouillons une fois les énergies du mois publiées par Enedis.',
                  ),
                ),
              ),
            AsyncData(value: final list) => Column(
                children: [for (final s in list) _AdminStatementTile(statement: s)],
              ),
            AsyncError(:final error) => Text(errorMessage(error)),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ],
      ),
    );
  }
}

class _RunReport extends StatelessWidget {
  const _RunReport({required this.report});

  final BillingRunOut report;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Brouillons calculés', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            for (final loop in report.loops)
              Text(
                '${loop.loopName} : ${loop.statements} relevé(s) · payé par les consommateurs '
                '${formatEuros(loop.consumersEur)} · reversé ${formatEuros(loop.payoutsEur)} · '
                'commission ${formatEuros(loop.commissionEur)}',
              ),
            for (final reason in report.skipped)
              Text('Non facturée — $reason', style: const TextStyle(color: Colors.deepOrange)),
            if (report.loops.isEmpty && report.skipped.isEmpty)
              const Text('Aucune boucle avec des membres actifs ce mois-ci.'),
          ],
        ),
      ),
    );
  }
}

class _AdminStatementTile extends StatelessWidget {
  const _AdminStatementTile({required this.statement});

  final AdminStatementOut statement;

  @override
  Widget build(BuildContext context) {
    final issued = statement.status == StatementStatus.issued;
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: Icon(
                statement.direction == MeterDirection.consumption
                    ? Icons.receipt_long_outlined
                    : Icons.savings_outlined,
              ),
              title: Text(
                '${statementKind(statement.direction)} — ${statement.firstName} ${statement.lastName}',
              ),
              subtitle: Text(
                '${statement.loopName} · ${formatKwhPrecise(statement.kwh)}\n'
                '${issued ? 'N° ${statement.number}' : 'Brouillon'}',
              ),
              isThreeLine: true,
              trailing: Text(
                formatEuros(statement.netEur),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: PdfButton(
                  statementId: statement.id,
                  number: statement.number,
                  label: issued ? 'PDF' : 'Aperçu PDF',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
