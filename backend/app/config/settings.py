import json
import os
from functools import lru_cache
from pathlib import Path

from dotenv import load_dotenv
from pydantic import BaseModel

PROJECT_ROOT = Path(__file__).resolve().parents[3]
ENV_FILE = PROJECT_ROOT / ".env"
load_dotenv(ENV_FILE)

DEFAULT_DEV_CORS_ALLOWED_ORIGINS = [
    "http://127.0.0.1:5173",
    "http://localhost:5173",
]
DEFAULT_DEV_PUBLIC_APP_URL = "http://127.0.0.1:5173"
DEFAULT_DEV_API_HOST = "127.0.0.1"
DEFAULT_DEV_API_PORT = 8000
APP_ENV = os.getenv("APP_ENV", "development").strip().lower()


def _normalize_url(value: str | None) -> str:
    if not value:
        return ""
    normalized = value.strip().strip('"').strip("'")
    if not normalized:
        return ""
    return normalized.rstrip("/")


def _parse_origin_list(value: str | None) -> list[str]:
    if value is None:
        return []

    raw_value = value.strip()
    if not raw_value:
        return []

    items: list[str]
    try:
        decoded = json.loads(raw_value)
    except json.JSONDecodeError:
        items = raw_value.split(",")
    else:
        if isinstance(decoded, list):
            items = [str(item) for item in decoded]
        elif isinstance(decoded, str):
            items = [decoded]
        else:
            items = []

    normalized_items: list[str] = []
    seen: set[str] = set()
    for item in items:
        normalized = _normalize_url(item)
        if normalized and normalized not in seen:
            normalized_items.append(normalized)
            seen.add(normalized)

    return normalized_items


def _resolve_cors_allowed_origins() -> list[str]:
    configured_origins = _parse_origin_list(os.getenv("CORS_ALLOWED_ORIGINS"))
    if configured_origins:
        return configured_origins
    if APP_ENV == "development":
        return DEFAULT_DEV_CORS_ALLOWED_ORIGINS.copy()
    return []


def _resolve_public_app_url() -> str:
    configured_url = _normalize_url(os.getenv("PUBLIC_APP_URL"))
    if configured_url:
        return configured_url
    if APP_ENV == "development":
        return DEFAULT_DEV_PUBLIC_APP_URL
    return ""


class Settings(BaseModel):
    app_env: str = APP_ENV
    db_host: str = os.getenv("DB_HOST", "127.0.0.1")
    db_port: int = int(os.getenv("DB_PORT", "3306"))
    db_name: str = os.getenv("DB_NAME", "formacion_db")
    db_user: str = os.getenv("DB_USER", "root")
    db_password: str = os.getenv("DB_PASSWORD", "")
    db_connect_timeout: int = int(os.getenv("DB_CONNECT_TIMEOUT", "10"))
    cors_allowed_origins: list[str] = _resolve_cors_allowed_origins()
    public_app_url: str = _resolve_public_app_url()
    api_host: str = os.getenv("API_HOST", DEFAULT_DEV_API_HOST if APP_ENV == "development" else "0.0.0.0")
    api_port: int = int(os.getenv("API_PORT", str(DEFAULT_DEV_API_PORT)))
    app_secret: str = os.getenv("APP_SECRET", "cambia-esta-clave-en-produccion")
    app_timezone: str = os.getenv("APP_TIMEZONE", "America/Bogota")

    @property
    def reload_enabled(self) -> bool:
        return self.app_env == "development"


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
