# SunShare

Application mobile de partage d'électricité solaire entre particuliers voisins, dans le cadre légal de
l'**autoconsommation collective** (ACC) en France. Un producteur (panneaux solaires) vend son surplus à
des consommateurs proches ; l'app organise l'opération, lit les données Linky via Enedis, calcule la
répartition et facture.

Développeur unique : Rémi, sur Windows 11 (Git Bash). Réponses et commentaires de code en français.

Cahier des charges complet : https://claude.ai/code/artifact/c29d0cf5-0e33-44ba-9554-23334a173002

## Règles métier à ne jamais oublier

- **Périmètre** : 2 km max entre les **deux sites les plus éloignés** de la boucle (un diamètre, pas un
  rayon autour d'un utilisateur). 10 ou 20 km possibles sur dérogation (zones rurales) → le périmètre est
  un paramètre de la boucle (`perimeter_km`).
- **L'app ne mesure rien** : les courbes de charge viennent d'Enedis, au **pas de 15 minutes** (pas de
  mesure et de répartition de l'ACC, confirmé par Enedis en novembre 2025 ; le cahier des charges
  initial disait 30 min). Enedis publie à la PMO les énergies réparties de l'opération en **M+1** ;
  les courbes individuelles peuvent arriver en J+1. Traitements en lots, jamais en temps réel.
- **C'est Enedis qui répartit l'énergie** à partir des clés envoyées par la PMO (personne morale
  organisatrice). La facturation repose **uniquement sur les données Enedis**, jamais sur notre simulation.
- **Argent** : `Decimal` en Python, `numeric` en base, jamais de flottant. Arrondi au centime une seule
  fois, sur le total mensuel. Les paiements passeront par un prestataire agréé (Mangopay ou Stripe
  Connect) : aucune donnée bancaire stockée chez nous.
- **RGPD** : les courbes de charge révèlent la présence au domicile → données sensibles. Un membre d'une
  boucle ne voit jamais les courbes d'un autre.

## Stack

| Couche | Choix |
| --- | --- |
| Mobile + back-office web | Flutter (Dart), Riverpod 3, dio, go_router, flutter_secure_storage, flutter_localizations (fr), fl_chart |
| Backend | Python **3.12**, FastAPI, Pydantic v2, SQLAlchemy 2, Alembic |
| Base | PostgreSQL 16 + PostGIS + TimescaleDB (image `timescale/timescaledb-ha:pg16`) |
| Auth | JWT (pyjwt, HS256) : accès 15 min + rafraîchissement 30 j ; mots de passe Argon2 (pwdlib) |
| CI | GitHub Actions : ruff, alembic upgrade, pytest, flutter analyze, flutter test |

## Structure du dépôt

```
SunShare/
├── CLAUDE.md
├── dev.sh                  # démarre la base + migrations + API
├── openapi.json            # schéma de l'API, généré (backend/scripts/export_openapi.py)
├── scripts/
│   ├── gen_client.sh       # openapi.json → client Dart (openapi-generator via Docker)
│   └── openapi-generator.yaml
├── .github/workflows/ci.yml
├── infra/
│   ├── docker-compose.yml  # base (port hôte 5433) + Adminer (http://localhost:8080)
│   ├── .env                # identifiants de la base (non commité)
│   └── initdb/01-extensions.sql
├── backend/
│   ├── .env                # DATABASE_URL, JWT_SECRET (non commité) ; modèle : .env.example
│   ├── requirements.txt / requirements-dev.txt
│   ├── app/
│   │   ├── main.py         # app FastAPI, CORS, /health, routeurs sous /api/v1
│   │   ├── config.py       # Settings (pydantic-settings)
│   │   ├── db.py           # engine, SessionLocal, get_db
│   │   ├── models.py       # User, Meter (+ enums UserRole, MeterDirection)
│   │   ├── schemas.py      # utilisateurs, jetons, compteurs (MeterCreate/Out), AddressSuggestion
│   │   ├── geocoding.py    # Base Adresse Nationale (Géoplateforme IGN) ; dépendance get_geocoder
│   │   ├── perimeter.py    # contrôle du périmètre (ST_Distance, marge de 50 m)
│   │   ├── loop_service.py # statistiques et conversions partagées des boucles
│   │   ├── allocation.py   # moteur de répartition (fonctions pures, Decimal, couverture ≥ 90 %)
│   │   ├── timesteps.py    # pas de mesure (15 min), conversion kW → kWh, journées françaises
│   │   ├── simulation.py   # courbes de charge simulées (déterministes)
│   │   ├── jobs.py         # traitement d'une journée : courbes simulées puis répartition
│   │   ├── dashboard.py    # courbe du jour et chiffres du mois d'un utilisateur
│   │   ├── money.py        # to_cents : arrondi au centime, une seule fois, sur le total
│   │   ├── billing.py      # relevés mensuels : montants, brouillons, émission numérotée
│   │   ├── statement_pdf.py # factures et relevés de reversement en PDF (reportlab)
│   │   ├── enedis/         # client.py (interface du connecteur PMO), importer.py (import mensuel)
│   │   ├── security.py     # hachage, création / décodage des jetons
│   │   ├── deps.py         # DbSession, get_current_user, CurrentUser
│   │   └── routers/        # auth, me, meters, addresses, loops, admin, dashboard, billing (/me/statements, /admin/billing)
│   ├── migrations/         # Alembic (env.py utilise geoalchemy2.alembic_helpers)
│   ├── scripts/            # export_openapi.py, promote_admin.py, simulate.py, import_enedis.py
│   └── tests/
└── mobile/                 # projet Flutter « sunshare » (org fr.sunshare)
    ├── lib/
    │   ├── main.dart       # MaterialApp.router
    │   ├── router.dart     # go_router : redirection selon la connexion ; onglets (StatefulShellRoute)
    │   ├── core/           # api, auth_interceptor, token_storage, api_errors, format (dates, €/kWh, km)
    │   └── features/       # auth/, home/ (onglets), dashboard/, loops/ (« Ma boucle »), admin/ (back-office), profile/, meters/, health/
    ├── packages/sunshare_api/  # client dart-dio GÉNÉRÉ (built_value) : ne jamais modifier à la main
    └── test/               # helpers.dart (faux repository, stockage en mémoire), parcours auth, intercepteur
```

## Commandes

Toutes depuis Git Bash. Docker Desktop doit être lancé.

```bash
# Tout démarrer (base + migrations + API sur http://localhost:8000)
./dev.sh

# Backend, dans backend/ avec le venv activé
source .venv/Scripts/activate
uvicorn app.main:app --reload          # API seule
ruff check .                            # lint
pytest -v                               # tests : base sunshare_test recréée à chaque lancement
alembic revision --autogenerate -m "..."  # nouvelle migration : TOUJOURS relire le fichier avant upgrade
alembic upgrade head
python scripts/promote_admin.py e-mail  # donne le rôle admin (PMO) : il ne se choisit pas à l'inscription
python scripts/simulate.py --du 2026-10-01 --au 2026-10-27   # courbes simulées + répartition (défaut : hier)
python scripts/import_enedis.py --mois 2026-10   # import Enedis (refuse tant qu'aucun accès n'est configuré)

# Client Dart : à relancer après toute modification d'une route ou d'un schéma Pydantic
./scripts/gen_client.sh                 # (Docker requis) ; la CI échoue si openapi.json est périmé

# Mobile, dans mobile/
flutter run -d chrome
flutter analyze                         # doit afficher « No issues found! » (la CI échoue sinon)
flutter test

# Base
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d
docker exec -it sunshare-db psql -U sunshare -d sunshare
```

Documentation interactive de l'API : http://localhost:8000/docs (bouton Authorize : e-mail dans `username`).

## Particularités du poste de Rémi (pièges déjà rencontrés)

- **Port 5433, pas 5432**, et **`127.0.0.1`, jamais `localhost`** dans `DATABASE_URL` : `wslrelay.exe`
  écoute sur `[::1]` (IPv6) et intercepte les connexions à `localhost`, ce qui donne une erreur
  « password authentication failed » trompeuse.
- **Python 3.12 obligatoire** pour le venv (`py -3.12 -m venv .venv`) : Python 3.15 est aussi installé,
  mais certains paquets n'y ont pas de wheel et exigent un compilateur C++.
- Le mot de passe PostgreSQL n'est lu qu'à la **création** du volume. Après un changement dans
  `infra/.env` : `docker compose down -v` puis `up -d`, ou `ALTER USER ... PASSWORD`.
- Lancer `uvicorn` depuis `backend/` (sinon `No module named 'app'`) et `docker compose` depuis
  `infra/` (sinon `.env` introuvable).
- Après un redémarrage du PC : lancer Docker Desktop, puis `./dev.sh`.

## Conventions

- API REST versionnée sous `/api/v1` ; erreurs au format FastAPI (`detail`) pour l'instant.
- `operationId` = nom de la fonction Python (`login`, `read_me`…) → méthodes du client Dart ; les
  `tags` donnent les classes (`AuthApi`, `ProfilApi`…). Toujours un `response_model` sur les routes.
- Client généré en mode `built_value` (le mode json_serializable envoie un formulaire vide à `login`).
- Mobile : le jeton est ajouté par `AuthInterceptor` (routes dont `extra['secure']` est non vide),
  qui rafraîchit sur 401 et rejoue une fois. Ne pas utiliser `setOAuthToken` du client généré.
- Mobile : l'écran ne navigue pas après connexion / déconnexion ; il change l'état
  d'`authControllerProvider` et `router.dart` redirige. Accueil de l'utilisateur connecté :
  « Tableau de bord » (`/accueil`), puis « Ma boucle » (`/boucle`) et « Profil » (`/profil`).
  L'administrateur a l'onglet « Boucles » (`/admin/boucles`, back-office) à la place des deux
  premiers ; `/admin/*` redirige les autres rôles (le serveur répond 403 de toute façon).
- Back-office : même application Flutter (cible web pour la PMO). Tarifs saisis convertis par
  `parseEurPerKwh` (« 0,18 » → « 0.18 ») et comparés par `eurPerKwhUnits` (entiers), sans `double`.
- Tests Flutter : `pumpApp` (test/helpers.dart) lance l'app complète sur des dépôts simulés
  (`FakeAuthRepository`, `FakeMetersRepository`, `FakeLoopsRepository`) ; `goToProfile` ouvre l'onglet.
- Mobile : tarifs et montants affichés avec `formatPrice` / `formatEuros`, qui travaillent sur la
  chaîne reçue (« 0.1800 » → « 0,18 €/kWh », « 25.65 » → « 25,65 € »), jamais via un `double`.
- Tableau de bord : tant que `data_source` vaut `simulated`, l'app affiche un bandeau « Estimation »
  et parle de montant « estimé » ; seules les données Enedis servent à facturer.
- Identifiants UUID générés par la base (`gen_random_uuid()`), horodatages `timestamptz` en UTC.
- E-mails stockés en minuscules.
- Adresses : l'app propose les suggestions de `/addresses` ; à la création d'un compteur, le
  serveur **re-géocode** le libellé (score ≥ 0,8, type `housenumber` ou `locality`) et ne fait jamais
  confiance à des coordonnées envoyées par le client (elles servent au contrôle du périmètre).
  Limite connue : un lieu-dit sans numéro typé `street` par la BAN est refusé.
- Tests backend : base **séparée** `sunshare_test` (nom de la base de dev + `_test`, même serveur),
  supprimée puis recréée et migrée à chaque `pytest` par `tests/conftest.py` ; garde-fou : refus si le
  nom ne finit pas par `_test`. `TEST_DATABASE_URL` permet d'en imposer une autre. Ne jamais importer
  `app` avant que conftest ait fixé `DATABASE_URL`.
- Tests backend : `tests/conftest.py` remplace le géocodeur par `FakeGeocoder` (aucun appel réseau) ;
  `site(km)` fabrique une adresse à km vers l'est d'Amiens pour tester les distances.
- Périmètre (`perimeter.py`, cahier des charges §8.1) : un site rejoint une boucle si sa distance au
  site **engagé** (demande `pending` ou membre `active`) le plus éloigné ne dépasse pas
  `perimeter_km − 50 m`. Verrou `FOR UPDATE` sur la boucle pendant l'adhésion. Un compteur n'est
  engagé que dans une boucle à la fois (index unique partiel).
- Tarifs (`EurPerKwh`) : `Decimal` en Python, `numeric(6,4)` en base, **chaîne** dans le JSON
  (`"0.1800"`), donc `String` côté Dart. Les grandeurs physiques (kWc, km) sont des nombres JSON.
- Les membres d'une boucle ne voient que des statistiques agrégées, jamais les autres membres.
- Courbes et répartitions : hypertables TimescaleDB `load_curves` (kW moyen sur 15 min, 3 décimales)
  et `allocations` (kWh par paire producteur → consommateur, 6 décimales, arrondi **vers le bas**
  pour ne jamais affecter plus que produit ou consommé). Colonne `source` : `simulated` ou `enedis` ;
  une courbe Enedis n'est jamais remplacée par une simulée, et seules les données Enedis facturent.
- Le pas, la conversion kWh = kW × 0,25 et les journées sont définis **uniquement** dans
  `app/timesteps.py` ; ne jamais coder 15 min, 0,25 ou 96 ailleurs (l'app mobile lit la durée du pas
  dans les horodatages). Une « journée » va de minuit à minuit heure de Paris : 96 pas, 92 ou 100 aux
  changements d'heure. Ne participent que les membres actifs dont la date d'entrée est passée.
- Clés de répartition prises en charge : `dynamic_default` (§8.2) et `static` (k_i × P plafonné à
  C_i) ; `dynamic_custom` lève `NotImplementedError` et la boucle est ignorée par le traitement.
- `tzdata` est requis (Windows n'a pas de base de fuseaux horaires pour `zoneinfo`).
- Enedis : tout passe par `EnedisOperationClient` (app/enedis/client.py), en termes métier (PRM + sens,
  kW par pas, kWh affectés par paire) ; **aucun format d'échange inventé** : le client réel s'écrira avec
  la documentation de la convention PMO. Jamais de faux client Enedis hors des tests : des données
  `enedis` simulées seraient facturées. `get_enedis_client()` lève `EnedisNotConfigured` en attendant.
- Import (`import_month`) : tout est récupéré avant d'écrire (3 tentatives, attente croissante),
  rejouable sans doublon, données `enedis` prioritaires sur la simulation ; ce qui ne se rattache pas
  à un membre actif ou sorti (PRM inconnu, sens inversé, pas mal aligné, hors période, valeur
  négative, doublon) est signalé dans `ImportReport.anomalies`, jamais importé.
- Montants (`EurAmount`) : calculés en Decimal sur les kWh exacts, arrondis par `to_cents` une seule
  fois sur le total mensuel, chaîne dans le JSON (`"25.65"`). Test de référence : l'exemple §8.3 du
  cahier des charges (142,5 kWh → 25,65 € / 2,85 € / 22,80 €, 7,4 kg de CO2).
- Facturation (`billing.py`, §8.3, TAR-02) : uniquement les énergies `enedis` (REP-03). Facture
  consommateur = kWh reçus × tarif (+ TURPE `network_fee_eur_kwh`, 0 par défaut) ; reversement
  producteur : brut = kWh × tarif, commission = kWh × commission, **net = brut − commission**
  (contrainte en base sur chaque relevé ; le tableau de bord applique les mêmes fonctions).
  Brouillon recalculable → émission : numéro `SS-AAAA-NNNNNN` **chronologique et sans trou** (compteur
  `statement_counters` verrouillé AVANT la lecture des brouillons), tarifs figés, plus jamais modifié ;
  les participants ne voient que les relevés émis. Ne jamais émettre sur la base de dev pour tester
  (le compteur avancerait) : les tests le couvrent sur la base de test.
- PDF (`statement_pdf.py`) : généré et **archivé en base à l'émission** (colonne `statements.pdf`,
  chargée à la demande), puis toujours resservi tel quel ; brouillon rendu à la volée avec filigrane,
  pour l'admin seulement. Rendu déterministe (`invariant=1`). Polices standard du PDF : pas de « − »
  typographique (signe moins ASCII). Identité de la PMO et mention de TVA = réglages `PMO_*` ; tant
  qu'ils manquent, « à compléter » s'imprime (aucune mention légale inventée).
- Tableau de bord : répartitions Enedis prioritaires sur la période si elles existent, sinon
  simulation (`data_source` = `simulated` → l'app doit présenter les chiffres comme une estimation).
  Facteur CO2 : `settings.co2_kg_per_kwh` (0,052, hypothèse à confirmer).
- Générateur dart-dio : pas de valeur par défaut de type enum dans un schéma d'entrée (le code
  généré ne compile pas) ; rendre le champ optionnel et appliquer le défaut côté serveur.
- Toute modification du schéma passe par une migration Alembic ; les tables PostGIS / TimescaleDB
  absentes des modèles sont ignorées par `include_object` dans `migrations/env.py`.
- Chaque fonctionnalité arrive avec ses tests ; la CI doit rester verte.
- Ne jamais commiter de `.env` ni de secret.

## Avancement

**Sprint 0 — terminé** : monorepo, base Docker, FastAPI + `/health`, Alembic (`users`, `meters`),
app Flutter qui appelle `/health`, CI GitHub Actions.

**Sprint 1** : authentification et compteurs.
- [x] Backend : `/auth/register`, `/auth/login`, `/auth/refresh`, `/me` + tests
- [x] Générer le client Dart depuis l'OpenAPI (`scripts/gen_client.sh`, testé de bout en bout)
- [x] Écrans Flutter : inscription, connexion, stockage des jetons (`flutter_secure_storage`),
      rafraîchissement automatique, écran profil
- [x] Ajout d'un compteur : adresse géocodée (Base Adresse Nationale) + PRM (14 chiffres)

**Sprint 1 — terminé.**

**Sprint 2** : boucles et contrôle du périmètre (exigences LOOP-01 à 04).
- [x] Backend : tables `loops` / `loop_members`, `/loops/available`, `/loops/{id}/join` (409 hors
      périmètre), `/loops/{id}`, `/me/memberships`, `/admin/loops` (création, modification,
      membres, validation avec date d'entrée, refus) + tests
- [x] Mobile utilisateur : onglets « Ma boucle » / « Profil », boucles disponibles, demande
      d'adhésion (tous les compteurs compatibles), annulation, détail agrégé de la boucle
- [x] Back-office administrateur (même app Flutter, onglet « Boucles ») : liste, création et
      modification d'une boucle, validation des demandes avec date d'entrée, refus

**Sprint 2 — terminé.**
- Reporté : consentement Enedis obligatoire avant l'adhésion (sprint Enedis), sortie d'un membre
  avec préavis (LOOP-05, P2), carte des participants aux positions floues.

**Sprint 3** : courbes simulées et moteur de répartition (REP-01, REP-02, DASH-01/02).
- [x] Backend : hypertables `load_curves` / `allocations`, moteur de répartition (100 % couvert),
      générateur de courbes, traitement par jour (`scripts/simulate.py`) ; mesuré au pas de 15 min :
      0,78 s par jour pour une boucle de 50 compteurs
- [x] API : `/me/curves?date=` (pas de 15 min : production, consommation, énergie reçue / vendue)
      et `/me/dashboard?period=` (kWh, montant estimé, commission, CO2 évité, taux) + tests
- [x] Mobile : onglet « Tableau de bord » (accueil) : mois (énergie locale, taux, montant estimé,
      revenu net, CO2) et journée (courbe fl_chart consommation / production / énergie locale)

**Sprint 3 — terminé.**
- Plus tard : planification automatique (APScheduler, worker séparé) avec la collecte Enedis.

**Sprint 4 — en cours** : intégration Enedis. Décisions du 28/10/2026 :
- [x] Passage au pas de 15 min (code, données simulées supprimées par migration, cahier des charges)
- [x] Canal prioritaire : **API PMO** de l'opération (courbes et énergies réparties de tous les
      participants, M+1, seule base de facturation) : interface, import mensuel avec anomalies et
      nouvelles tentatives, `scripts/import_enedis.py`, tests avec un faux client
- [ ] Client réel de l'API PMO : bloqué tant qu'il n'y a pas de convention PMO ni de documentation
      (aucun accès Enedis pour l'instant)
- [ ] Back-office : anomalies d'import et lancement de l'import par l'administrateur
- Plus tard : Data Connect (consentement de chaque participant, courbes en J+1), en transition vers
  « Data Connect 2026 » ; planification nocturne (worker).

**Sprint 5 — en cours** : facturation (sans Enedis réel ni prestataire de paiement).
- [x] Backend : table `statements` (+ compteur de numérotation), calcul des brouillons du mois,
      émission, `/admin/billing/run|issue|statements`, `/me/statements`, `/statements/{id}` ;
      couverture 100 % (CI : `app.allocation` et `app.billing` ≥ 90 %)
- [x] Factures et relevés en PDF (PAY-03) : `GET /statements/{id}/pdf`, archivage à l'émission
- [ ] App : historique et détail des relevés ; back-office : lancer, vérifier, émettre la facturation
- [ ] Paiements (PAY-01, 02, 04, 05) : bloqués sans compte Mangopay / Stripe Connect
- Plus tard : avoirs (correction d'un relevé émis), historique des tarifs (TAR-03), planification.

**Sprints suivants** : pilote.

**Plus tard** : vérification de l'e-mail, révocation des jetons.
