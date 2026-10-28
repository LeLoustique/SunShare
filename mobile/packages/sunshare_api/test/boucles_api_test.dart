import 'package:test/test.dart';
import 'package:sunshare_api/sunshare_api.dart';


/// tests for BouclesApi
void main() {
  final instance = SunshareApi().getBouclesApi();

  group(BouclesApi, () {
    // Cancel Membership
    //
    // Annule une demande encore en attente (la sortie d'un membre actif viendra plus tard).
    //
    //Future cancelMembership(String membershipId) async
    test('test cancelMembership', () async {
      // TODO
    });

    // Join Loop
    //
    // Demande d'adhésion d'un compteur ; validée ensuite par l'administrateur de la PMO.
    //
    //Future<MembershipOut> joinLoop(String loopId, JoinRequest joinRequest) async
    test('test joinLoop', () async {
      // TODO
    });

    // List Available Loops
    //
    // Boucles ouvertes que les compteurs libres de l'utilisateur peuvent rejoindre.
    //
    //Future<BuiltList<AvailableLoop>> listAvailableLoops() async
    test('test listAvailableLoops', () async {
      // TODO
    });

    // List My Memberships
    //
    // Demandes et participations de l'utilisateur, toutes boucles et tous statuts confondus.
    //
    //Future<BuiltList<MembershipOut>> listMyMemberships() async
    test('test listMyMemberships', () async {
      // TODO
    });

    // Read Loop
    //
    // Détail d'une boucle, réservé à ses membres (demande en cours comprise) et à l'administrateur.
    //
    //Future<LoopOut> readLoop(String loopId) async
    test('test readLoop', () async {
      // TODO
    });

  });
}
