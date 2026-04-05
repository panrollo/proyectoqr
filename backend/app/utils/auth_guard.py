from fastapi import Header, HTTPException

from app.config.settings import settings
from app.utils.security import decode_session_token


def require_session(authorization: str | None = Header(default=None)) -> dict:
    if not authorization:
        raise HTTPException(status_code=401, detail="Debes iniciar sesion para usar esta API.")

    scheme, _, token = authorization.partition(" ")
    if scheme.lower() != "bearer" or not token:
        raise HTTPException(status_code=401, detail="El encabezado de autorizacion no es valido.")

    try:
        return decode_session_token(token, settings.app_secret)
    except ValueError as exc:
        raise HTTPException(status_code=401, detail=str(exc)) from exc
