import 'package:test/test.dart';
import 'package:sunshare_api/sunshare_api.dart';


/// tests for AdminApi
void main() {
  final instance = SunshareApi().getAdminApi();

  group(AdminApi, () {
    // Admin Approve Member
    //
    // Valide l'adhésion et fixe la date d'entrée dans l'opération.  Pas de nouveau contrôle du périmètre : une demande en attente y est déjà prise en compte.
    //
    //Future<AdminMemberOut> adminApproveMember(String loopId, String memberId, ApproveRequest approveRequest) async
    test('test adminApproveMember', () async {
      // TODO
    });

    // Admin Create Loop
    //
    //Future<AdminLoopOut> adminCreateLoop(LoopCreate loopCreate) async
    test('test adminCreateLoop', () async {
      // TODO
    });

    // Admin List Loops
    //
    //Future<BuiltList<AdminLoopOut>> adminListLoops() async
    test('test adminListLoops', () async {
      // TODO
    });

    // Admin List Members
    //
    //Future<BuiltList<AdminMemberOut>> adminListMembers(String loopId) async
    test('test adminListMembers', () async {
      // TODO
    });

    // Admin Reject Member
    //
    //Future<AdminMemberOut> adminRejectMember(String loopId, String memberId) async
    test('test adminRejectMember', () async {
      // TODO
    });

    // Admin Update Loop
    //
    //Future<AdminLoopOut> adminUpdateLoop(String loopId, LoopUpdate loopUpdate) async
    test('test adminUpdateLoop', () async {
      // TODO
    });

  });
}
