-- Exécuté automatiquement à la première création de la base.
-- Pour le rejouer : docker compose down -v, puis docker compose up -d

CREATE EXTENSION IF NOT EXISTS timescaledb;   -- séries temporelles (courbes de charge)
CREATE EXTENSION IF NOT EXISTS postgis;       -- distances géographiques (périmètre)
CREATE EXTENSION IF NOT EXISTS pgcrypto;      -- gen_random_uuid() pour les identifiants
