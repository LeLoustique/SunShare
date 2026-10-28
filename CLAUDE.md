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
- **L'app ne mesure rien** : les courbes de charge viennent d'Enedis, au pas de 30 minutes, en **J+1**.
  Traitements en lots (quotidiens / mensuels), jamais en temps réel.
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
| Mobile | Flutter (Dart), Riverpod 3, dio, go_router, flutter_secure_storage ; fl_chart à venir |
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
│   │   ├── security.py     # hachage, création / décodage des jetons
│   │   ├── deps.py         # DbSession, get_current_user, CurrentUser
│   │   └── routers/        # auth.py, me.py, meters.py (/meters), addresses.py (/addresses)
│   ├── migrations/         # Alembic (env.py utilise geoalchemy2.alembic_helpers)
│   ├── scripts/export_openapi.py
│   └── tests/
└── mobile/                 # projet Flutter « sunshare » (org fr.sunshare)
    ├── lib/
    │   ├── main.dart       # MaterialApp.router
    │   ├── router.dart     # go_router : redirection selon l'état de connexion
    │   ├── core/           # api.dart (dio + client), auth_interceptor.dart, token_storage.dart, api_errors.dart
    │   └── features/       # auth/, profile/, meters/ (liste, ajout avec autocomplétion), health/
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
pytest -v                               # tests (la base doit tourner)
alembic revision --autogenerate -m "..."  # nouvelle migration : TOUJOURS relire le fichier avant upgrade
alembic upgrade head

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
  d'`authControllerProvider` et `router.dart` redirige. Tests : surcharger `authRepositoryProvider`.
- Identifiants UUID générés par la base (`gen_random_uuid()`), horodatages `timestamptz` en UTC.
- E-mails stockés en minuscules.
- Adresses : l'app propose les suggestions de `/addresses` ; à la création d'un compteur, le
  serveur **re-géocode** le libellé (score ≥ 0,8, type `housenumber` ou `locality`) et ne fait jamais
  confiance à des coordonnées envoyées par le client (elles servent au contrôle du périmètre).
  Limite connue : un lieu-dit sans numéro typé `street` par la BAN est refusé.
- Tests backend : surcharger `get_geocoder` (`app.dependency_overrides`), jamais d'appel réseau.
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

**Sprints suivants** : boucles et contrôle du périmètre (PostGIS) → courbes simulées et moteur de
répartition → intégration Enedis (sandbox Data Connect) → facturation et paiements → pilote.

**Plus tard** : vérification de l'e-mail, révocation des jetons, base de test séparée pour pytest.
