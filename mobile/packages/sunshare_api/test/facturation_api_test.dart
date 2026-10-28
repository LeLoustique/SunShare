import 'package:test/test.dart';
import 'package:sunshare_api/sunshare_api.dart';


/// tests for FacturationApi
void main() {
  final instance = SunshareApi().getFacturationApi();

  group(FacturationApi, () {
    // List My Statements
    //
    // Relevés émis de l'utilisateur, du plus récent au plus ancien (brouillons cachés).
    //
    //Future<BuiltList<StatementOut>> listMyStatements() async
    test('test listMyStatements', () async {
      // TODO
    });

    // Read Statement
    //
    //Future<StatementOut> readStatement(String statementId) async
    test('test readStatement', () async {
      // TODO
    });

  });
}
