#!/usr/bin/env bash
# Démarre la base et l'API SunShare. Docker Desktop doit être lancé.
set -e
cd "$(dirname "$0")"

docker compose -f infra/docker-compose.yml --env-file infra/.env up -d --wait
cd backend
source .venv/Scripts/activate
alembic upgrade head
uvicorn app.main:app --reload
