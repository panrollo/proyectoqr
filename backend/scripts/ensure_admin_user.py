import os
import sys
from pathlib import Path


CURRENT_FILE = Path(__file__).resolve()
BACKEND_DIR = CURRENT_FILE.parents[1]
sys.path.insert(0, str(BACKEND_DIR))

from app.services.admin_bootstrap_service import ensure_admin_user, format_json


def _required_env(name: str) -> str:
    value = os.getenv(name, "").strip()
    if not value:
        raise ValueError(f"Falta la variable de entorno requerida: {name}")
    return value


def _pick(source: dict, *keys: str):
    for key in keys:
        if key in source:
            return source[key]
    return None


def main() -> int:
    try:
        result = ensure_admin_user(
            full_name=_required_env("BOOTSTRAP_ADMIN_NAME"),
            email=_required_env("BOOTSTRAP_ADMIN_EMAIL"),
            password=_required_env("BOOTSTRAP_ADMIN_PASSWORD"),
        )
    except Exception as exc:
        print(str(exc), file=sys.stderr)
        return 1

    safe_result = {
        "status": result["status"],
        "action": result["action"],
        "role": result["role"],
        "user": {
            "user_id": _pick(result["user"], "user_id", "id_usuario"),
            "full_name": _pick(result["user"], "full_name", "nombre_completo"),
            "email": _pick(result["user"], "email", "correo"),
            "role_key": _pick(result["user"], "role_key", "rol_nombre"),
            "status": _pick(result["user"], "status", "estado"),
        },
    }
    print(format_json(safe_result))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
