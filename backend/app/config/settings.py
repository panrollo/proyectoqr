import os
from functools import lru_cache
from pathlib import Path

from dotenv import load_dotenv
from pydantic import BaseModel

PROJECT_ROOT = Path(__file__).resolve().parents[3]
ENV_FILE = PROJECT_ROOT / ".env"
load_dotenv(ENV_FILE)


def _split_csv(value: str | None, fallback: str) -> list[str]:
    source = value or fallback
    return [item.strip() for item in source.split(",") if item.strip()]


class Settings(BaseModel):
    app_env: str = os.getenv("APP_ENV", "development").lower()
    db_host: str = os.getenv("DB_HOST", "127.0.0.1")
    db_port: int = int(os.getenv("DB_PORT", "3306"))
    db_name: str = os.getenv("DB_NAME", "formacion_db")
    db_user: str = os.getenv("DB_USER", "root")
    db_password: str = os.getenv("DB_PASSWORD", "")
    db_connect_timeout: int = int(os.getenv("DB_CONNECT_TIMEOUT", "10"))
    cors_allowed_origins: list[str] = _split_csv(
        os.getenv("CORS_ALLOWED_ORIGINS"),
        "http://127.0.0.1:5173,http://localhost:5173",
    )
    public_app_url: str = os.getenv("PUBLIC_APP_URL", "http://127.0.0.1:5173")
    api_host: str = os.getenv("API_HOST", "127.0.0.1")
    api_port: int = int(os.getenv("API_PORT", "8000"))
    app_secret: str = os.getenv("APP_SECRET", "cambia-esta-clave-en-produccion")
    app_timezone: str = os.getenv("APP_TIMEZONE", "America/Bogota")

    @property
    def reload_enabled(self) -> bool:
        return self.app_env == "development"


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
