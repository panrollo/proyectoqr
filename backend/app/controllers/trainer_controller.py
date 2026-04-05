from fastapi import HTTPException

from app.services.procedure_service import execute_write
from app.services.query_service import fetch_all


def _ensure_formador(session_user: dict) -> None:
    if session_user.get("profile_key") != "formador":
        raise HTTPException(status_code=403, detail="Solo los formadores pueden usar este modulo.")


def _get_session_for_trainer(session_user: dict, virtual_session_id: int) -> dict:
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


def list_attendance_sessions(session_user: dict):
    _ensure_formador(session_user)
    return fetch_all("trainer_attendance_sessions", {"trainer_user_id": session_user["user_id"]})


def get_attendance_records(session_user: dict, virtual_session_id: int):
    session = _get_session_for_trainer(session_user, virtual_session_id)
    records = fetch_all(
        "trainer_attendance_records",
        {
            "trainer_user_id": session_user["user_id"],
            "virtual_session_id": virtual_session_id,
        },
    )
    return {
        "session": session,
        "records": records,
    }


def save_session_link(session_user: dict, virtual_session_id: int, payload):
    _get_session_for_trainer(session_user, virtual_session_id)
    return execute_write("attendance_sessions", "save_link", [virtual_session_id, str(payload.join_url)])
