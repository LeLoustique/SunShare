import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api_errors.dart';
import '../../core/format.dart';
import 'statements_repository.dart';

/// Détail d'une facture ou d'un relevé de reversement, et son PDF.
class StatementDetailScreen extends ConsumerWidget {
  const StatementDetailScreen({super.key, required this.statementId});

  final String statementId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(statementProvider(statementId))) {
      AsyncData(value: final statement) => _Detail(statement: statement),
      AsyncError(:final error) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text(errorMessage(error))),
        ),
      _ => Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator())),
    };
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.statement});

  final StatementOut statement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final invoice = isInvoice(statement);
    final issued = statement.issuedAt;
    final hasNetworkFee = statement.networkFeeEur != '0.00';

    return Scaffold(
      appBar: AppBar(title: Text('${statementKind(statement.direction)} ${statement.number ?? ''}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(formatPeriod(statement.period), style: theme.textTheme.headlineSmall),
          Text('Boucle ${statement.loopName}'),
          if (issued != null) Text('Émis le ${formatDateTime(issued)}'),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _Line(
                    invoice ? 'Énergie locale reçue' : 'Énergie vendue dans la boucle',
                    formatKwhPrecise(statement.kwh),
                  ),
                  _Line('Tarif', formatPrice(statement.priceEurKwh)),
                  if (hasNetworkFee)
                    _Line('Acheminement (TURPE)', formatEuros(statement.networkFeeEur)),
                  if (!invoice) ...[
                    _Line('Montant brut', formatEuros(statement.grossEur)),
                    _Line(
                      'Commission (${formatPrice(statement.commissionEurKwh)})',
                      '-${formatEuros(statement.commissionEur)}',
                    ),
                  ],
                  const Divider(height: 24),
                  _Line(
                    invoice ? 'Total à payer' : 'Net reversé',
                    formatEuros(statement.netEur),
                    bold: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Montants calculés à partir des énergies réparties publiées par Enedis.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          PdfButton(statementId: statement.id, number: statement.number),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16) : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

/// Télécharge le PDF puis l'ouvre (partage sur mobile, téléchargement sur le web).
class PdfButton extends ConsumerStatefulWidget {
  const PdfButton({super.key, required this.statementId, required this.number, this.label});

  final String statementId;
  final String? number;
  final String? label;

  @override
  ConsumerState<PdfButton> createState() => _PdfButtonState();
}

class _PdfButtonState extends ConsumerState<PdfButton> {
  bool _loading = false;

  Future<void> _open() async {
    setState(() => _loading = true);
    try {
      final bytes = await ref.read(statementsRepositoryProvider).pdf(widget.statementId);
      await ref.read(pdfOpenerProvider)(bytes, pdfFilename(widget.statementId, widget.number));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(e))));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: _loading ? null : _open,
      icon: _loading
          ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.picture_as_pdf_outlined),
      label: Text(widget.label ?? 'Ouvrir le PDF'),
    );
  }
}
