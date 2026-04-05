import base64
import hashlib
import hmac
import json
import uuid
from datetime import datetime, timedelta, timezone

from passlib.hash import pbkdf2_sha256


ROLE_ALIAS = {
    "superadmin": "admin",
}
SESSION_TTL_HOURS = 8


def hash_password(raw_password: str) -> str:
    return pbkdf2_sha256.hash(raw_password)


def verify_password(raw_password: str, password_hash: str) -> bool:
    return pbkdf2_sha256.verify(raw_password, password_hash)


def map_role_key(role_key: str) -> str:
    return ROLE_ALIAS.get(role_key, role_key)


def generate_qr_code() -> str:
    return str(uuid.uuid4())


def generate_group_code() -> str:
    return f"OPR-{datetime.now().strftime('%Y%m%d%H%M%S')}"


def _encode_segment(value: bytes) -> str:
    return base64.urlsafe_b64encode(value).decode("utf-8").rstrip("=")


def _decode_segment(value: str) -> bytes:
    padding = "=" * (-len(value) % 4)
    return base64.urlsafe_b64decode(f"{value}{padding}")


def create_signed_token(payload: dict, secret: str) -> str:
    payload_segment = _encode_segment(json.dumps(payload, separators=(",", ":")).encode("utf-8"))
    signature = hmac.new(secret.encode("utf-8"), payload_segment.encode("utf-8"), hashlib.sha256).digest()
    return f"{payload_segment}.{_encode_segment(signature)}"


def decode_signed_token(token: str, secret: str, validate_expiration: bool = True) -> dict:
    try:
        payload_segment, signature_segment = token.split(".", 1)
    except ValueError as exc:
        raise ValueError("Token malformado.") from exc

    expected_signature = hmac.new(secret.encode("utf-8"), payload_segment.encode("utf-8"), hashlib.sha256).digest()
    provided_signature = _decode_segment(signature_segment)
    if not hmac.compare_digest(expected_signature, provided_signature):
        raise ValueError("Token invalido.")

    payload = json.loads(_decode_segment(payload_segment).decode("utf-8"))
    if validate_expiration and int(payload.get("exp", 0)) < int(datetime.now(timezone.utc).timestamp()):
        raise ValueError("El token ya expiro.")

    return payload


def create_session_token(user: dict, secret: str) -> str:
    expires_at = datetime.now(timezone.utc) + timedelta(hours=SESSION_TTL_HOURS)
    payload = {
        "user_id": user["user_id"],
        "email": user["email"],
        "role_key": user["role_key"],
        "profile_key": user["profile_key"],
        "exp": int(expires_at.timestamp()),
    }
    return create_signed_token(payload, secret)


def decode_session_token(token: str, secret: str) -> dict:
    payload = decode_signed_token(token, secret, validate_expiration=True)
    if payload.get("exp") is None:
        raise ValueError("La sesion ya expiro.")
    return payload
