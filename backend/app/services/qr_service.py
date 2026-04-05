from datetime import datetime, timedelta, timezone
from io import BytesIO
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

import qrcode
import qrcode.image.svg

from app.config.settings import settings
from app.utils.security import create_signed_token, decode_signed_token


QR_KIND = "session_attendance"


def get_local_timezone() -> ZoneInfo:
    try:
        return ZoneInfo(settings.app_timezone)
    except ZoneInfoNotFoundError:
        return timezone(timedelta(hours=-5))


def localize_database_datetime(value: datetime | None) -> datetime | None:
    if value is None:
        return None
    if value.tzinfo is not None:
        return value.astimezone(get_local_timezone())
    return value.replace(tzinfo=get_local_timezone())


def get_now_local() -> datetime:
    return datetime.now(get_local_timezone())


def get_now_utc() -> datetime:
    return datetime.now(timezone.utc)


def build_public_qr_url(qr_token: str) -> str:
    return f"{settings.public_app_url.rstrip('/')}/encuesta-asistencia/{qr_token}"


def create_qr_access_token(virtual_session_id: int, qr_type: str, active_from: datetime, expires_at: datetime, nonce: str) -> str:
    active_from_utc = active_from.astimezone(timezone.utc)
    expires_at_utc = expires_at.astimezone(timezone.utc)
    payload = {
        "kind": QR_KIND,
        "sid": virtual_session_id,
        "qtype": qr_type.upper(),
        "nbf": int(active_from_utc.timestamp()),
        "exp": int(expires_at_utc.timestamp()),
        "nonce": nonce,
    }
    return create_signed_token(payload, settings.app_secret)


def decode_qr_access_token(qr_token: str, validate_expiration: bool = False) -> dict:
    payload = decode_signed_token(qr_token, settings.app_secret, validate_expiration=validate_expiration)
    if payload.get("kind") != QR_KIND:
        raise ValueError("El token QR no corresponde al modulo de asistencia.")
    return payload


def resolve_qr_window_status(active_from: datetime, expires_at: datetime, now_local: datetime | None = None) -> str:
    comparison_time = now_local or get_now_local()
    if comparison_time < active_from:
        return "PENDIENTE"
    if comparison_time > expires_at:
        return "EXPIRADO"
    return "VIGENTE"


def build_qr_svg(public_url: str) -> str:
    qr_image = qrcode.make(public_url, image_factory=qrcode.image.svg.SvgPathImage, box_size=8, border=3)
    buffer = BytesIO()
    qr_image.save(buffer)
    return buffer.getvalue().decode("utf-8")
