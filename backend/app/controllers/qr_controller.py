import re
import secrets
from datetime import timedelta

from fastapi import HTTPException

from app.services.procedure_service import execute_write
from app.services.qr_service import (
    build_public_qr_url,
    build_qr_svg,
    create_qr_access_token,
    decode_qr_access_token,
    get_now_local,
    localize_database_datetime,
    resolve_qr_window_status,
)
from app.services.query_service import fetch_all

CEDULA_PATTERN = re.compile(r"^[0-9]{6,12}$")


def _ensure_formador(session_user: dict) -> None:
    if session_user.get("profile_key") != "formador":
        raise HTTPException(status_code=403, detail="Solo los formadores pueden usar este modulo.")


def _get_trainer_session(session_user: dict, virtual_session_id: int) -> dict:
    _ensure_formador(session_user)
    sessions = fetch_all(
        "trainer_attendance_sessions",
        {
            "trainer_user_id": session_user["user_id"],
            "virtual_session_id": virtual_session_id,
        },
    )
    if not sessions:
        raise HTTPException(status_code=404, detail="La sesion indicada no pertenece al formador autenticado.")
    return sessions[0]


def _load_qr_row(qr_token: str) -> dict | None:
    rows = fetch_all("public_qr_access", {"qr_token": qr_token})
    return rows[0] if rows else None


def _resolve_qr_message(window_status: str) -> str:
    if window_status == "VIGENTE":
        return "El QR esta habilitado y puedes diligenciar la encuesta de asistencia."
    if window_status == "PENDIENTE":
        return "El QR todavia no esta habilitado para esta encuesta de asistencia."
    return "El QR ya expiro para esta encuesta de asistencia."


def _validate_document_number(document_number: str) -> str:
    normalized_number = document_number.strip()
    if not normalized_number:
        raise HTTPException(status_code=400, detail="La cedula es obligatoria.")
    if not CEDULA_PATTERN.fullmatch(normalized_number):
        raise HTTPException(status_code=400, detail="La cedula debe contener entre 6 y 12 digitos.")
    return normalized_number


def _build_public_qr_payload(qr_row: dict) -> dict:
    active_from = localize_database_datetime(qr_row["active_from"])
    expires_at = localize_database_datetime(qr_row["expires_at"])
    window_status = resolve_qr_window_status(active_from, expires_at)
    return {
        "access_status": window_status,
        "message": _resolve_qr_message(window_status),
        "is_form_enabled": window_status == "VIGENTE",
        "qr": {
            "session_qr_id": qr_row["session_qr_id"],
            "qr_type": qr_row["qr_type"],
            "qr_token": qr_row["qr_token"],
            "active_from": active_from.isoformat(),
            "expires_at": expires_at.isoformat(),
            "public_url": qr_row["public_url"],
        },
        "session": {
            "virtual_session_id": qr_row["virtual_session_id"],
            "planner_id": qr_row["planner_id"],
            "group_id": qr_row["group_id"],
            "group_code": qr_row["group_code"],
            "group_name": qr_row["group_name"],
            "activity_id": qr_row["activity_id"],
            "activity_name": qr_row["activity_name"],
            "campaign_id": qr_row["campaign_id"],
            "campaign_name": qr_row["campaign_name"],
            "session_start_at": localize_database_datetime(qr_row["session_start_at"]).isoformat(),
            "session_status": qr_row["session_status"],
        },
        "form": {
            "form_type": "ENCUESTA_ASISTENCIA",
            "campaigns": [
                {
                    "campaign_id": qr_row["campaign_id"],
                    "campaign_name": qr_row["campaign_name"],
                }
            ],
            "required_fields": ["full_name", "document_number", "campaign_id"],
        },
    }


def _ensure_qr_payload_matches_row(token_payload: dict, qr_row: dict) -> None:
    row_active_from = localize_database_datetime(qr_row["active_from"])
    row_expires_at = localize_database_datetime(qr_row["expires_at"])
    if token_payload.get("sid") != qr_row["virtual_session_id"]:
        raise HTTPException(status_code=400, detail="El token QR no coincide con la sesion configurada.")
    if token_payload.get("qtype") != qr_row["qr_type"]:
        raise HTTPException(status_code=400, detail="El token QR no coincide con el tipo de ventana configurado.")
    if token_payload.get("nbf") != int(row_active_from.timestamp()) or token_payload.get("exp") != int(row_expires_at.timestamp()):
        raise HTTPException(status_code=400, detail="El token QR no coincide con la vigencia registrada.")


def _register_invalid_attempt(
    qr_row: dict | None,
    qr_token: str,
    payload,
    validation_status: str,
    client_ip: str | None,
    user_agent: str | None,
    observation: str,
) -> dict:
    document_type = None
    full_name = payload.full_name if payload else "Intento sin nombre"
    document_number = payload.document_number if payload else "SIN_DOCUMENTO"
    campaign_id = payload.campaign_id if payload else None
    qr_type = qr_row["qr_type"] if qr_row else None
    session_qr_id = qr_row["session_qr_id"] if qr_row else None
    session_id = qr_row["virtual_session_id"] if qr_row else None
    return execute_write(
        "public_qr_attendance",
        "invalid",
        [
            session_id,
            session_qr_id,
            qr_token,
            qr_type,
            document_type,
            full_name,
            document_number,
            campaign_id,
            validation_status,
            client_ip,
            user_agent,
            observation,
        ],
    )


def list_trainer_session_qr_codes(session_user: dict, virtual_session_id: int) -> list[dict]:
    _get_trainer_session(session_user, virtual_session_id)
    return fetch_all(
        "trainer_session_qr_codes",
        {
            "trainer_user_id": session_user["user_id"],
            "virtual_session_id": virtual_session_id,
        },
    )


def generate_trainer_session_qr_codes(session_user: dict, virtual_session_id: int) -> list[dict]:
    session = _get_trainer_session(session_user, virtual_session_id)
    session_start_at = localize_database_datetime(session["start_at"])
    if session_start_at is None:
        raise HTTPException(status_code=400, detail="La sesion no tiene fecha de inicio configurada.")

    qr_windows = [
        ("ASISTENCIA", session_start_at - timedelta(minutes=5), session_start_at + timedelta(minutes=5)),
        ("RETARDO", session_start_at + timedelta(minutes=15), session_start_at + timedelta(minutes=30)),
    ]

    for qr_type, active_from, expires_at in qr_windows:
        qr_token = create_qr_access_token(
            virtual_session_id=virtual_session_id,
            qr_type=qr_type,
            active_from=active_from,
            expires_at=expires_at,
            nonce=secrets.token_urlsafe(10),
        )
        public_url = build_public_qr_url(qr_token)
        execute_write(
            "session_qr_codes",
            "upsert",
            [
                virtual_session_id,
                qr_type,
                qr_token,
                public_url,
                active_from.replace(tzinfo=None),
                expires_at.replace(tzinfo=None),
            ],
        )

    return list_trainer_session_qr_codes(session_user, virtual_session_id)


def get_public_qr_access(qr_token: str) -> dict:
    qr_row = _load_qr_row(qr_token)
    if not qr_row:
        raise HTTPException(status_code=404, detail="El QR no existe o ya no esta disponible.")

    try:
        token_payload = decode_qr_access_token(qr_token, validate_expiration=False)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc

    _ensure_qr_payload_matches_row(token_payload, qr_row)
    return _build_public_qr_payload(qr_row)


def render_public_qr_image(qr_token: str) -> str:
    qr_row = _load_qr_row(qr_token)
    if not qr_row:
        raise HTTPException(status_code=404, detail="El QR no existe o ya no esta disponible.")
    try:
        token_payload = decode_qr_access_token(qr_token, validate_expiration=False)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    _ensure_qr_payload_matches_row(token_payload, qr_row)
    return build_qr_svg(qr_row["public_url"])


def submit_public_qr_access(qr_token: str, payload, client_ip: str | None, user_agent: str | None) -> dict:
    qr_row = _load_qr_row(qr_token)

    try:
        token_payload = decode_qr_access_token(qr_token, validate_expiration=False)
    except ValueError as exc:
        _register_invalid_attempt(
            qr_row=qr_row,
            qr_token=qr_token,
            payload=payload,
            validation_status="TOKEN_INVALIDO",
            client_ip=client_ip,
            user_agent=user_agent,
            observation=str(exc),
        )
        raise HTTPException(status_code=400, detail="El QR es invalido o fue alterado.") from exc

    if not qr_row:
        _register_invalid_attempt(
            qr_row=None,
            qr_token=qr_token,
            payload=payload,
            validation_status="TOKEN_INVALIDO",
            client_ip=client_ip,
            user_agent=user_agent,
            observation="Token firmado sin registro vigente en la base de datos.",
        )
        raise HTTPException(status_code=404, detail="El QR no existe o ya no esta disponible.")

    _ensure_qr_payload_matches_row(token_payload, qr_row)

    qr_access = _build_public_qr_payload(qr_row)
    if qr_access["access_status"] != "VIGENTE":
        validation_status = "QR_PENDIENTE" if qr_access["access_status"] == "PENDIENTE" else "QR_EXPIRADO"
        _register_invalid_attempt(
            qr_row=qr_row,
            qr_token=qr_token,
            payload=payload,
            validation_status=validation_status,
            client_ip=client_ip,
            user_agent=user_agent,
            observation=qr_access["message"],
        )
        raise HTTPException(status_code=409, detail=qr_access["message"])

    normalized_document_number = _validate_document_number(payload.document_number)

    if payload.campaign_id != qr_row["campaign_id"]:
        _register_invalid_attempt(
            qr_row=qr_row,
            qr_token=qr_token,
            payload=payload,
            validation_status="CAMPANA_INVALIDA",
            client_ip=client_ip,
            user_agent=user_agent,
            observation="La campana seleccionada no corresponde a la sesion del QR.",
        )
        raise HTTPException(status_code=400, detail="La campana seleccionada no corresponde a la sesion.")

    expected_people = fetch_all(
        "session_expected_people",
        {
            "virtual_session_id": qr_row["virtual_session_id"],
            "document_number": normalized_document_number,
            "campaign_id": payload.campaign_id,
        },
    )

    if not expected_people:
        _register_invalid_attempt(
            qr_row=qr_row,
            qr_token=qr_token,
            payload=payload,
            validation_status="NO_AUTORIZADO",
            client_ip=client_ip,
            user_agent=user_agent,
            observation="La persona no hace parte de la lista autorizada del grupo o de HC.",
        )
        raise HTTPException(status_code=403, detail="La persona no esta autorizada para esta sesion.")

    active_people = [item for item in expected_people if int(item.get("is_active") or 0) == 1]
    if not active_people:
        _register_invalid_attempt(
            qr_row=qr_row,
            qr_token=qr_token,
            payload=payload,
            validation_status="NO_AUTORIZADO",
            client_ip=client_ip,
            user_agent=user_agent,
            observation="La persona existe en la sesion, pero su estado no esta activo.",
        )
        raise HTTPException(status_code=403, detail="La persona no tiene un estado activo para esta sesion.")

    person = active_people[0]
    if not person.get("is_in_hc"):
        _register_invalid_attempt(
            qr_row=qr_row,
            qr_token=qr_token,
            payload=payload,
            validation_status="SIN_HC",
            client_ip=client_ip,
            user_agent=user_agent,
            observation="La persona existe en la lista del grupo, pero no tiene HC asociado.",
        )
        raise HTTPException(status_code=403, detail="La persona no tiene HC asociado y no puede marcar asistencia.")

    observation_parts = []
    expected_name = (person.get("full_name") or "").strip()
    if expected_name and expected_name.lower() != payload.full_name.strip().lower():
        observation_parts.append("Nombre capturado difiere del nombre registrado en HC.")

    registration = execute_write(
        "public_qr_attendance",
        "register",
        [
            qr_row["virtual_session_id"],
            qr_row["session_qr_id"],
            qr_token,
            qr_row["qr_type"],
            person["document_type"],
            person["person_id"],
            payload.full_name.strip(),
            normalized_document_number,
            payload.campaign_id,
            client_ip,
            user_agent,
            " ".join(observation_parts) if observation_parts else None,
        ],
    )

    normalized_records = fetch_all("attendance_qr_records", {"attendance_record_id": registration["attendance_record_id"]})
    if normalized_records:
        registration = normalized_records[0]

    validation_status = registration.get("validation_status")
    detail_message = {
        "ASISTIO": "Asistencia registrada correctamente en Wave.",
        "RETARDO": "Retardo registrado correctamente en Wave.",
        "DUPLICADO": "La persona ya tenia un registro valido con esta misma ventana.",
        "DUPLICADO_IGNORADO": "La persona ya estaba marcada como ASISTIO; el retardo no reemplazo el registro previo.",
    }.get(validation_status, "La transaccion QR fue procesada.")

    return {
        "message": detail_message,
        "record": registration,
        "session": qr_access["session"],
    }


def list_expected_people(session_user: dict, virtual_session_id: int) -> list[dict]:
    _get_trainer_session(session_user, virtual_session_id)
    return fetch_all("session_expected_people", {"virtual_session_id": virtual_session_id})


def list_room_validation(session_user: dict, virtual_session_id: int) -> list[dict]:
    _get_trainer_session(session_user, virtual_session_id)
    return fetch_all(
        "session_room_validation",
        {
            "trainer_user_id": session_user["user_id"],
            "virtual_session_id": virtual_session_id,
        },
    )


def request_room_expel(session_user: dict, virtual_session_id: int, teams_participant_id: str, payload) -> dict:
    _get_trainer_session(session_user, virtual_session_id)
    room_validation = list_room_validation(session_user, virtual_session_id)
    participant = next((item for item in room_validation if item["teams_participant_id"] == teams_participant_id), None)
    if not participant:
        raise HTTPException(status_code=404, detail="El participante de sala no pertenece a la sesion consultada.")

    detail = payload.detail or "Solicitud de expulsion registrada; pendiente integracion con la API de Teams."
    execute_write(
        "bot_moderation",
        "log",
        [
            virtual_session_id,
            teams_participant_id,
            "EXPULSAR_SOLICITADO",
            "PENDIENTE_INTEGRACION",
            detail,
        ],
    )
    return {
        "supported": False,
        "message": "La expulsion automatica no esta disponible en el stack actual. La solicitud quedo registrada para integracion con Bot/Teams.",
        "participant": participant,
    }
