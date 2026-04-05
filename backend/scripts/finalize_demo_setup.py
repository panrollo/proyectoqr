import json
import sys
from pathlib import Path


CURRENT_FILE = Path(__file__).resolve()
BACKEND_DIR = CURRENT_FILE.parents[1]
sys.path.insert(0, str(BACKEND_DIR))

from app.controllers.auth_controller import login
from app.controllers.qr_controller import generate_trainer_session_qr_codes
from app.database.connection import get_connection
from app.schemas.auth import LoginRequest
from app.services.query_service import fetch_all


TRAINER_SESSIONS = [
    {
        "email": "formador1@local.test",
        "password": "Formador12345!",
        "virtual_session_id": 7101,
        "attendance_rows": [7301, 7303],
        "retardo_rows": [7302],
    },
    {
        "email": "formador2@local.test",
        "password": "Formador12345!",
        "virtual_session_id": 7102,
        "attendance_rows": [7304, 7305],
        "retardo_rows": [],
    },
]


def _login_user(email: str, password: str) -> dict:
    payload = LoginRequest(identifier=email, password=password)
    result = login(payload)
    return result["user"]


def _load_qr_rows(trainer_user_id: int, virtual_session_id: int) -> dict[str, dict]:
    rows = fetch_all(
        "trainer_session_qr_codes",
        {"trainer_user_id": trainer_user_id, "virtual_session_id": virtual_session_id},
    )
    return {row["qr_type"].upper(): row for row in rows}


def _update_seed_attendance_rows(virtual_session_id: int, qr_rows: dict[str, dict], attendance_rows: list[int], retardo_rows: list[int]) -> None:
    with get_connection() as connection:
        with connection.cursor() as cursor:
            for row_id in attendance_rows:
                attendance_qr = qr_rows["ASISTENCIA"]
                cursor.execute(
                    """
                    UPDATE asistencia_scan
                    SET id_sesion_virtual = %s,
                        id_sesion_virtual_qr = %s,
                        qr_token_capturado = %s,
                        tipo_qr = 'ASISTENCIA'
                    WHERE id_asistencia_scan = %s
                    """,
                    (
                        virtual_session_id,
                        attendance_qr["session_qr_id"],
                        attendance_qr["qr_token"],
                        row_id,
                    ),
                )

            for row_id in retardo_rows:
                retardo_qr = qr_rows["RETARDO"]
                cursor.execute(
                    """
                    UPDATE asistencia_scan
                    SET id_sesion_virtual = %s,
                        id_sesion_virtual_qr = %s,
                        qr_token_capturado = %s,
                        tipo_qr = 'RETARDO'
                    WHERE id_asistencia_scan = %s
                    """,
                    (
                        virtual_session_id,
                        retardo_qr["session_qr_id"],
                        retardo_qr["qr_token"],
                        row_id,
                    ),
                )
        connection.commit()


def main() -> int:
    summary: list[dict] = []
    for config in TRAINER_SESSIONS:
        session_user = _login_user(config["email"], config["password"])
        qr_rows = generate_trainer_session_qr_codes(session_user, config["virtual_session_id"])
        qr_map = {row["qr_type"].upper(): row for row in qr_rows}
        _update_seed_attendance_rows(
            virtual_session_id=config["virtual_session_id"],
            qr_rows=qr_map,
            attendance_rows=config["attendance_rows"],
            retardo_rows=config["retardo_rows"],
        )
        summary.append(
            {
                "trainer": config["email"],
                "virtual_session_id": config["virtual_session_id"],
                "qr_types": {
                    qr_type: {
                        "session_qr_id": row["session_qr_id"],
                        "qr_status": row["qr_status"],
                        "public_url": row["public_url"],
                    }
                    for qr_type, row in qr_map.items()
                },
            }
        )

    print(json.dumps({"status": "ok", "sessions": summary}, indent=2, ensure_ascii=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
