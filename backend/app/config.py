from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env")

    database_url: str
    jwt_secret: str
    access_token_minutes: int = 15
    refresh_token_days: int = 30
    # Base Adresse Nationale, servie par la Géoplateforme IGN (successeur d'api-adresse.data.gouv.fr)
    geocoding_url: str = "https://data.geopf.fr/geocodage"


settings = Settings()
