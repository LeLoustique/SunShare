#!/usr/bin/env bash
# Régénère le client Dart de l'API (mobile/packages/sunshare_api) à partir du code du backend.
# À lancer après toute modification d'une route ou d'un schéma Pydantic. Docker Desktop doit tourner.
set -e
cd "$(dirname "$0")/.."
ROOT="$(pwd -W 2>/dev/null || pwd)"   # chemin Windows sous Git Bash, pour le montage Docker
OUT=mobile/packages/sunshare_api

# 1. Schéma OpenAPI calculé depuis le code (l'API n'a pas besoin de tourner)
(cd backend && source .venv/Scripts/activate && python scripts/export_openapi.py)

# 2. Génération du client dart-dio (image Docker : pas besoin d'installer Java)
rm -rf "$OUT"
MSYS_NO_PATHCONV=1 docker run --rm -v "$ROOT:/local" openapitools/openapi-generator-cli:v7.12.0 generate \
  -i /local/openapi.json \
  -g dart-dio \
  -o /local/$OUT \
  -c /local/scripts/openapi-generator.yaml

# 3. Code des modèles (built_value) puis formatage
cd "$OUT"
dart pub get
dart run build_runner build
dart format --line-length 100 lib > /dev/null
echo "Client régénéré dans $OUT"
