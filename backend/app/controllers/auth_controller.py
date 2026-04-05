from fastapi import HTTPException

from app.config.settings import settings
from app.services.query_service import fetch_all
from app.utils.security import create_session_token, map_role_key, verify_password


def _normalize_identifier(identifier: str) -> str:
    normalized = identifier.strip().lower()
    if not normalized:
        raise HTTPException(status_code=400, detail="Debes ingresar un usuario o correo.")
    return normalized


def login(payload):
    login_identity = _normalize_identifier(payload.identifier)
    users = fetch_all("auth_access", {"login_identity": login_identity, "status": 1})
    if not users:
        raise HTTPException(status_code=401, detail="Credenciales invalidas.")

    user = users[0]

    if not verify_password(payload.password, user["password_hash"]):
        raise HTTPException(status_code=401, detail="Credenciales invalidas.")

    session_user = {
        "user_id": user["user_id"],
        "full_name": user["full_name"],
        "email": user["email"],
        "role_key": user["role_key"],
        "profile_key": map_role_key(user["role_key"]),
        "qr_code": user["qr_code"],
    }

    return {
        "token": create_session_token(session_user, settings.app_secret),
        "user": session_user,
    }
