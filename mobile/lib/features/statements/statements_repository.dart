import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api.dart';
import '../auth/auth_controller.dart';

class StatementsRepository {
  StatementsRepository(this._api);

  final SunshareApi _api;

  FacturationApi get _billing => _api.getFacturationApi();

  /// Relevés émis de l'utilisateur, du plus récent au plus ancien.
  Future<List<StatementOut>> mine() async => (await _billing.listMyStatements()).data!.toList();

  Future<StatementOut> statement(String id) async =>
      (await _billing.readStatement(statementId: id)).data!;

  /// PDF archivé à l'émission (ou aperçu « BROUILLON » pour l'administrateur).
  Future<Uint8List> pdf(String id) async =>
      (await _billing.downloadStatementPdf(statementId: id)).data!;
}

final statementsRepositoryProvider =
    Provider<StatementsRepository>((ref) => StatementsRepository(ref.watch(apiProvider)));

final myStatementsProvider = FutureProvider<List<StatementOut>>((ref) {
  ref.watch(authControllerProvider.select((auth) => auth.value?.id));
  return ref.watch(statementsRepositoryProvider).mine();
});

final statementProvider = FutureProvider.family<StatementOut, String>(
  (ref, id) => ref.watch(statementsRepositoryProvider).statement(id),
);

/// Ouvre un PDF : téléchargement sur le web, feuille de partage sur mobile. Remplacé dans les tests.
typedef PdfOpener = Future<void> Function(Uint8List bytes, String filename);

final pdfOpenerProvider = Provider<PdfOpener>(
  (ref) => (bytes, filename) async {
    await Printing.sharePdf(bytes: bytes, filename: filename);
  },
);

bool isInvoice(StatementOut s) => s.direction == MeterDirection.consumption;

/// « Facture » (consommateur) ou « Reversement » (producteur).
String statementKind(MeterDirection direction) =>
    direction == MeterDirection.consumption ? 'Facture' : 'Reversement';

String pdfFilename(String id, String? number) => '${number ?? 'brouillon-$id'}.pdf';
