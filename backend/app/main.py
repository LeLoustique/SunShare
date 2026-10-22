from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import text

from app.db import engine

app = FastAPI(title="SunShare API", version="0.1.0")

# En développement : autorise l'app Flutter web lancée sur n'importe quel port local
app.add_middleware(
    CORSMiddleware,
    allow_origin_regex=r"http://(localhost|127\.0\.0\.1)(:\d+)?",
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def health():
    """Vérifie que l'API joint la base et que les extensions sont actives."""
    with engine.connect() as conn:
        rows = conn.execute(
            text("SELECT extname, extversion FROM pg_extension "
                 "WHERE extname IN ('postgis', 'timescaledb', 'pgcrypto')")
        ).all()
    return {"status": "ok", "extensions": {name: version for name, version in rows}}
