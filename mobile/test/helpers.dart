import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunshare/core/token_storage.dart';
import 'package:sunshare/features/admin/admin_repository.dart';
import 'package:sunshare/features/auth/auth_repository.dart';
import 'package:sunshare/features/dashboard/dashboard_repository.dart';
import 'package:sunshare/features/loops/loops_repository.dart';
import 'package:sunshare/features/meters/meters_repository.dart';
import 'package:sunshare/features/statements/statements_repository.dart';
import 'package:sunshare/main.dart';
import 'package:sunshare_api/sunshare_api.dart';

const validPassword = 'motdepasse123';

final camille = UserOut((b) => b
  ..id = '0b4c8a1e-0000-4000-8000-000000000001'
  ..email = 'camille@exemple.fr'
  ..firstName = 'Camille'
  ..lastName = 'Martin'
  ..role = UserRole.producer
  ..createdAt = DateTime.utc(2026, 10, 28, 9));

/// Erreur telle que la renvoie le client généré quand l'API répond `{"detail": ...}`.
DioException apiError(int status, String detail) {
  final options = RequestOptions(path: '/');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: options, statusCode: status, data: {'detail': detail}),
  );
}

class MemoryTokenStorage implements TokenStorage {
  MemoryTokenStorage([this.tokens]);

  Tokens? tokens;

  @override
  Future<Tokens?> read() async => tokens;

  @override
  Future<void> save(Tokens tokens) async => this.tokens = tokens;

  @override
  Future<void> clear() async => tokens = null;
}

/// Démarre l'application complète sur des dépôts simulés (aucun appel réseau).
Future<void> pumpApp(
  WidgetTester tester, {
  required FakeAuthRepository auth,
  FakeMetersRepository? meters,
  FakeLoopsRepository? loops,
  FakeAdminRepository? admin,
  FakeDashboardRepository? dashboard,
  FakeStatementsRepository? statements,
}) async {
  // Écran assez haut pour que les formulaires tiennent sans défilement
  tester.view.physicalSize = const Size(1000, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final metersRepository = meters ?? FakeMetersRepository();
  final statementsRepository = statements ?? FakeStatementsRepository();
  await tester.pumpWidget(ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(auth),
      metersRepositoryProvider.overrideWithValue(metersRepository),
      loopsRepositoryProvider.overrideWithValue(loops ?? FakeLoopsRepository(metersRepository)),
      adminRepositoryProvider.overrideWithValue(admin ?? FakeAdminRepository()),
      dashboardRepositoryProvider.overrideWithValue(dashboard ?? FakeDashboardRepository()),
      statementsRepositoryProvider.overrideWithValue(statementsRepository),
      // Pas de vrai partage dans les tests : on note le fichier qui aurait été ouvert
      pdfOpenerProvider.overrideWithValue(
        (bytes, filename) async => statementsRepository.opened.add(filename),
      ),
    ],
    child: const SunShareApp(),
  ));
  await tester.pumpAndSettle();
}

/// L'accueil est le tableau de bord : ouvre l'onglet Profil.
Future<void> goToProfile(WidgetTester tester) async {
  await tester.tap(find.text('Profil'));
  await tester.pumpAndSettle();
}

/// Ouvre l'onglet « Ma boucle ».
Future<void> goToLoop(WidgetTester tester) async {
  await tester.tap(find.text('Ma boucle'));
  await tester.pumpAndSettle();
}

/// Simule l'API : un seul compte (camille@exemple.fr / motdepasse123), producteur par défaut.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.loggedIn = false, UserRole? role})
      : user = camille.rebuild((b) => b..role = role ?? UserRole.producer);

  bool loggedIn;
  final UserOut user;
  UserCreate? registered;

  @override
  Future<UserOut?> restoreSession() async => loggedIn ? user : null;

  @override
  Future<UserOut> login(String email, String password) async {
    if (email.trim() != camille.email || password != validPassword) {
      throw apiError(401, 'E-mail ou mot de passe incorrect');
    }
    loggedIn = true;
    return user;
  }

  @override
  Future<UserOut> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    if (email.trim() == camille.email) {
      throw apiError(409, 'Un compte existe déjà avec cet e-mail');
    }
    registered = UserCreate((b) => b
      ..email = email
      ..password = password
      ..firstName = firstName
      ..lastName = lastName
      ..role = role);
    loggedIn = true;
    return camille.rebuild((b) => b
      ..email = email
      ..firstName = firstName
      ..lastName = lastName
      ..role = role);
  }

  @override
  Future<UserOut> me() async => user;

  @override
  Future<void> logout() async => loggedIn = false;
}

final amiens = AddressSuggestion((b) => b
  ..label = '8 Boulevard du Port 80000 Amiens'
  ..postcode = '80000'
  ..city = 'Amiens'
  ..latitude = 49.897442
  ..longitude = 2.290084);

/// Simule /meters et /addresses : ne connaît que l'adresse [amiens].
class FakeMetersRepository implements MetersRepository {
  FakeMetersRepository([List<MeterOut>? meters]) : meters = meters ?? [];

  final List<MeterOut> meters;
  final searches = <String>[];

  @override
  Future<List<MeterOut>> list() async => List.of(meters);

  @override
  Future<MeterOut> create({
    required String prm,
    required MeterDirection direction,
    required String address,
    num? peakKw,
  }) async {
    if (meters.any((m) => m.prm == prm && m.direction == direction)) {
      throw apiError(409, 'Ce compteur est déjà enregistré');
    }
    final meter = MeterOut((b) => b
      ..id = 'compteur-${meters.length + 1}'
      ..prm = prm
      ..direction = direction
      ..address = address
      ..latitude = amiens.latitude
      ..longitude = amiens.longitude
      ..peakKw = peakKw
      ..createdAt = DateTime.utc(2026, 10, 28));
    meters.add(meter);
    return meter;
  }

  @override
  Future<void> delete(String id) async => meters.removeWhere((m) => m.id == id);

  @override
  Future<List<AddressSuggestion>> searchAddresses(String query) async {
    searches.add(query);
    return query.toLowerCase().contains('port') ? [amiens] : [];
  }
}

MeterOut meter({
  required String prm,
  MeterDirection? direction,
  num? peakKw,
}) =>
    MeterOut((b) => b
      ..id = 'compteur-$prm'
      ..prm = prm
      ..direction = direction ?? MeterDirection.consumption
      ..address = amiens.label
      ..latitude = amiens.latitude
      ..longitude = amiens.longitude
      ..peakKw = peakKw
      ..createdAt = DateTime.utc(2026, 10, 28));

AvailableLoop availableLoop({
  String id = 'boucle-1',
  String name = 'Saint-Leu',
  String price = '0.1800',
  required List<String> joinable,
}) =>
    AvailableLoop((b) => b
      ..id = id
      ..name = name
      ..perimeterKm = 2
      ..priceEurKwh = price
      ..memberCount = 3
      ..joinableMeterIds.addAll(joinable));

LoopOut loopOut({String id = 'boucle-1', String name = 'Saint-Leu'}) => LoopOut((b) => b
  ..id = id
  ..name = name
  ..perimeterKm = 2
  ..priceEurKwh = '0.1800'
  ..status = LoopStatus.open
  ..stats.memberCount = 3
  ..stats.producerCount = 1
  ..stats.consumerCount = 2
  ..stats.totalPeakKw = 9
  ..stats.diameterKm = 0.814);

MembershipOut membership(
  MeterOut meter, {
  String loopId = 'boucle-1',
  String loopName = 'Saint-Leu',
  MembershipStatus? status,
  Date? joinedAt,
}) =>
    MembershipOut((b) => b
      ..id = 'adhesion-${meter.id}-$loopId'
      ..loopId = loopId
      ..loopName = loopName
      ..meterId = meter.id
      ..prm = meter.prm
      ..direction = meter.direction
      ..status = status ?? MembershipStatus.pending
      ..requestedAt = DateTime.utc(2026, 10, 28)
      ..joinedAt = joinedAt);

/// Simule /loops et /me/memberships. Une adhésion crée une demande en attente ; [refusedLoops]
/// répondent 409 (hors périmètre).
class FakeLoopsRepository implements LoopsRepository {
  FakeLoopsRepository(
    this._meters, {
    List<AvailableLoop>? available,
    List<MembershipOut>? memberships,
    this.refusedLoops = const {},
  })  : availableLoops = available ?? [],
        membershipList = memberships ?? [];

  final FakeMetersRepository _meters;
  final List<AvailableLoop> availableLoops;
  final List<MembershipOut> membershipList;
  final Set<String> refusedLoops;

  bool _engaged(String meterId) =>
      membershipList.any((m) => m.meterId == meterId && isEngaged(m));

  @override
  Future<List<AvailableLoop>> available() async => [
        for (final loop in availableLoops)
          if (loop.joinableMeterIds.any((id) => !_engaged(id)))
            loop.rebuild((b) => b.joinableMeterIds.where((id) => !_engaged(id))),
      ];

  @override
  Future<List<MembershipOut>> memberships() async => List.of(membershipList);

  @override
  Future<LoopOut> loop(String id) async {
    final name = membershipList.firstWhere((m) => m.loopId == id).loopName;
    return loopOut(id: id, name: name);
  }

  @override
  Future<MembershipOut> join(String loopId, String meterId) async {
    if (refusedLoops.contains(loopId)) {
      throw apiError(409, 'Votre compteur est hors du périmètre de la boucle');
    }
    final loop = availableLoops.firstWhere((l) => l.id == loopId);
    final meter = _meters.meters.firstWhere((m) => m.id == meterId);
    final created = membership(meter, loopId: loopId, loopName: loop.name);
    membershipList.insert(0, created);
    return created;
  }

  @override
  Future<void> cancel(String membershipId) async =>
      membershipList.removeWhere((m) => m.id == membershipId);
}

AdminLoopOut adminLoop({
  String id = 'boucle-1',
  String name = 'Saint-Leu',
  String price = '0.1800',
  String commission = '0.0200',
  int pendingCount = 0,
  LoopStatus? status,
}) =>
    AdminLoopOut((b) => b
      ..id = id
      ..name = name
      ..perimeterKm = 2
      ..priceEurKwh = price
      ..commissionEurKwh = commission
      ..status = status ?? LoopStatus.open
      ..allocationMode = AllocationMode.dynamicDefault
      ..pendingCount = pendingCount
      ..createdAt = DateTime.utc(2026, 10, 28)
      ..stats.memberCount = 0
      ..stats.producerCount = 0
      ..stats.consumerCount = 0
      ..stats.totalPeakKw = 0
      ..stats.diameterKm = 0);

AdminMemberOut adminMember({
  required String id,
  String loopId = 'boucle-1',
  String firstName = 'Alex',
  String lastName = 'Durand',
  MembershipStatus? status,
}) =>
    AdminMemberOut((b) => b
      ..id = id
      ..loopId = loopId
      ..loopName = 'Saint-Leu'
      ..meterId = 'compteur-$id'
      ..prm = '12345678901234'
      ..direction = MeterDirection.consumption
      ..status = status ?? MembershipStatus.pending
      ..requestedAt = DateTime.utc(2026, 10, 28)
      ..firstName = firstName
      ..lastName = lastName
      ..email = '${firstName.toLowerCase()}@exemple.fr'
      ..address = amiens.label);

/// Simule /admin/loops : garde les boucles et les adhésions en mémoire.
class FakeAdminRepository implements AdminRepository {
  FakeAdminRepository({
    List<AdminLoopOut>? loops,
    List<AdminMemberOut>? members,
    List<AdminStatementOut>? computedDrafts,
  })  : loopList = loops ?? [],
        memberList = members ?? [],
        drafts = computedDrafts ?? [];

  final List<AdminLoopOut> loopList;
  final List<AdminMemberOut> memberList;
  final approvals = <String, Date>{};

  /// Brouillons que « Calculer » produira, et relevés connus (brouillons puis émis)
  final List<AdminStatementOut> drafts;
  final statementList = <AdminStatementOut>[];
  final billingRuns = <String>[];
  var _lastNumber = 0;

  @override
  Future<List<AdminLoopOut>> loops() async => List.of(loopList);

  @override
  Future<AdminLoopOut> create(LoopCreate loop) async {
    final created = adminLoop(
      id: 'boucle-${loopList.length + 1}',
      name: loop.name,
      price: loop.priceEurKwh,
      commission: loop.commissionEurKwh,
    ).rebuild((b) => b..perimeterKm = loop.perimeterKm ?? 2);
    loopList.add(created);
    return created;
  }

  @override
  Future<AdminLoopOut> update(String loopId, LoopUpdate changes) async {
    final index = loopList.indexWhere((l) => l.id == loopId);
    final updated = loopList[index].rebuild((b) {
      if (changes.name != null) b.name = changes.name;
      if (changes.priceEurKwh != null) b.priceEurKwh = changes.priceEurKwh;
      if (changes.commissionEurKwh != null) b.commissionEurKwh = changes.commissionEurKwh;
      if (changes.status != null) b.status = changes.status;
    });
    loopList[index] = updated;
    return updated;
  }

  @override
  Future<List<AdminMemberOut>> members(String loopId) async =>
      memberList.where((m) => m.loopId == loopId).toList();

  AdminMemberOut _setStatus(String memberId, MembershipStatus status, {Date? joinedAt}) {
    final index = memberList.indexWhere((m) => m.id == memberId);
    memberList[index] = memberList[index].rebuild((b) => b
      ..status = status
      ..joinedAt = joinedAt);
    return memberList[index];
  }

  @override
  Future<AdminMemberOut> approve(String loopId, String memberId, Date joinedAt) async {
    approvals[memberId] = joinedAt;
    return _setStatus(memberId, MembershipStatus.active, joinedAt: joinedAt);
  }

  @override
  Future<AdminMemberOut> reject(String loopId, String memberId) async =>
      _setStatus(memberId, MembershipStatus.rejected);

  @override
  Future<BillingRunOut> runBilling(String month) async {
    billingRuns.add(month);
    statementList
      ..removeWhere((s) => s.period == month && s.status == StatementStatus.draft)
      ..addAll(drafts.map((d) => d.rebuild((b) => b..period = month)));
    return BillingRunOut((b) => b
      ..period = month
      ..loops.add(LoopBillingOut((l) => l
        ..loopId = 'boucle-1'
        ..loopName = 'Saint-Leu'
        ..statements = drafts.length
        ..consumersEur = '27.45'
        ..payoutsEur = '24.40'
        ..commissionEur = '3.05')));
  }

  @override
  Future<IssueOut> issueStatements(String month) async {
    final numbers = <String>[];
    for (final (i, s) in statementList.indexed) {
      if (s.period != month || s.status != StatementStatus.draft) continue;
      final number = 'SS-2026-${(++_lastNumber).toString().padLeft(6, '0')}';
      numbers.add(number);
      statementList[i] = s.rebuild((b) => b
        ..status = StatementStatus.issued
        ..number = number);
    }
    return IssueOut((b) => b
      ..period = month
      ..issued = numbers.length
      ..firstNumber = numbers.first
      ..lastNumber = numbers.last);
  }

  @override
  Future<List<AdminStatementOut>> statements(String month) async =>
      statementList.where((s) => s.period == month).toList();
}

StatementOut statementOut({
  String id = 'releve-1',
  String number = 'SS-2026-000001',
  String period = '2026-10',
  MeterDirection? direction,
  String gross = '25.65',
  String commission = '0.00',
  String net = '25.65',
}) =>
    StatementOut((b) => b
      ..id = id
      ..number = number
      ..loopId = 'boucle-1'
      ..loopName = 'Saint-Leu'
      ..period = period
      ..direction = direction ?? MeterDirection.consumption
      ..status = StatementStatus.issued
      ..kwh = 142.5
      ..priceEurKwh = '0.1800'
      ..commissionEurKwh = '0.0200'
      ..networkFeeEurKwh = '0.0000'
      ..grossEur = gross
      ..networkFeeEur = '0.00'
      ..commissionEur = commission
      ..netEur = net
      ..issuedAt = DateTime.utc(2026, 11, 3, 9));

AdminStatementOut draftStatement({required String id, String firstName = 'Alex', MeterDirection? direction}) =>
    AdminStatementOut((b) => b
      ..id = id
      ..loopId = 'boucle-1'
      ..loopName = 'Saint-Leu'
      ..period = '2026-10'
      ..direction = direction ?? MeterDirection.consumption
      ..status = StatementStatus.draft
      ..kwh = 142.5
      ..priceEurKwh = '0.1800'
      ..commissionEurKwh = '0.0200'
      ..networkFeeEurKwh = '0.0000'
      ..grossEur = '25.65'
      ..networkFeeEur = '0.00'
      ..commissionEur = '0.00'
      ..netEur = '25.65'
      ..firstName = firstName
      ..lastName = 'Durand'
      ..email = '${firstName.toLowerCase()}@exemple.fr');

/// Simule /me/statements, /statements/{id} et le PDF ; `opened` = fichiers « ouverts ».
class FakeStatementsRepository implements StatementsRepository {
  FakeStatementsRepository([List<StatementOut>? statements]) : statementList = statements ?? [];

  final List<StatementOut> statementList;
  final opened = <String>[];

  @override
  Future<List<StatementOut>> mine() async => List.of(statementList);

  @override
  Future<StatementOut> statement(String id) async => statementList.firstWhere((s) => s.id == id);

  @override
  Future<Uint8List> pdf(String id) async => Uint8List.fromList('%PDF-1.4 $id'.codeUnits);
}

/// Simule /me/dashboard et /me/curves : par défaut, un utilisateur sans compteur ni données.
class FakeDashboardRepository implements DashboardRepository {
  FakeDashboardRepository({this.monthData, this.dayData});

  final Dashboard? monthData;
  final DayCurves? dayData;
  final requestedPeriods = <String>[];
  final requestedDays = <Date>[];

  @override
  Future<Dashboard> month(String period) async {
    requestedPeriods.add(period);
    return (monthData ?? emptyDashboard()).rebuild((b) => b..period = period);
  }

  @override
  Future<DayCurves> day(Date day) async {
    requestedDays.add(day);
    return (dayData ?? DayCurves((b) => b..day = day)).rebuild((b) => b..day = day);
  }
}

Dashboard emptyDashboard() => Dashboard((b) => b
  ..period = '2026-10'
  ..co2AvoidedKg = 0
  ..co2KgPerKwh = 0.052);
