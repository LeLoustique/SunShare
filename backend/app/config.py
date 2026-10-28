from decimal import Decimal

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env")

    database_url: str
    jwt_secret: str
    access_token_minutes: int = 15
    refresh_token_days: int = 30
    # Base Adresse Nationale, servie par la Géoplateforme IGN (successeur d'api-adresse.data.gouv.fr)
    geocoding_url: str = "https://data.geopf.fr/geocodage"
    # CO2 évité par kWh consommé localement plutôt que pris au réseau. Hypothèse à confirmer
    # (question ouverte du cahier des charges) : 0,052 kg/kWh, cohérent avec son exemple
    # (142,5 kWh → 7,4 kg).
    co2_kg_per_kwh: Decimal = Decimal("0.052")
    # TURPE sur la part autoconsommée, facturé au consommateur : en principe non collecté par la PMO,
    # 0 en attendant confirmation (cahier des charges §8.3)
    network_fee_eur_kwh: Decimal = Decimal(0)
    # Accès aux données Enedis de l'opération : « none » tant qu'il n'y a pas de convention PMO
    enedis_mode: str = "none"


settings = Settings()
