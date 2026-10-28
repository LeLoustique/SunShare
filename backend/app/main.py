from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.routing import APIRoute
from sqlalchemy import text

from app.db import engine
from app.routers import auth, me
from app.schemas import HealthOut


def operation_id(route: APIRoute) -> str:
    """operationId = nom de la fonction : le client Dart généré expose `login()`, `readMe()`…"""
    return route.name


app = FastAPI(title="SunShare API", version="0.2.0", generate_unique_id_function=operation_id)

# En développement : autorise l'app Flutter web lancée sur n'importe quel port local
app.add_middleware(
    CORSMiddleware,
    allow_origin_regex=r"http://(localhost|127\.0\.0\.1)(:\d+)?",
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api/v1")
app.include_router(me.router, prefix="/api/v1")


@app.get("/health", tags=["technique"], response_model=HealthOut)
def health():
    """Vérifie que l'API joint la base et que les extensions sont actives."""
    with engine.connect() as conn:
        rows = conn.execute(
            text("SELECT extname, extversion FROM pg_extension "
                 "WHERE extname IN ('postgis', 'timescaledb', 'pgcrypto')")
        ).all()
    return {"status": "ok", "extensions": {name: version for name, version in rows}}
