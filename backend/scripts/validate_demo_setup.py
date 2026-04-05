import json
import sys
from pathlib import Path

from fastapi.testclient import TestClient


CURRENT_FILE = Path(__file__).resolve()
BACKEND_DIR = CURRENT_FILE.parents[1]
sys.path.insert(0, str(BACKEND_DIR))

from app.app import app


DEMO_USERS = [
    ("admin", "admin@local.test", "Admin12345!"),
    ("formador", "formador1@local.test", "Formador12345!"),
    ("lider", "lider@local.test", "Lider12345!"),
    ("jefe_fc", "jefe.fc@local.test", "JefeFC12345!"),
    ("analista", "analista@local.test", "Analista12345!"),
    ("supervisor", "supervisor@local.test", "Supervisor12345!"),
    ("jefe_ops", "jefe.ops@local.test", "JefeOps12345!"),
    ("agente", "agente@local.test", "Agente12345!"),
]


def _login(client: TestClient, email: str, password: str) -> dict:
    response = client.post(
        "/api/auth/login",
        json={"identifier": email, "password": password},
    )
    response.raise_for_status()
    return response.json()


def main() -> int:
    client = TestClient(app)

    health_response = client.get("/health")
    health_response.raise_for_status()

    login_results: dict[str, dict] = {}
    tokens: dict[str, str] = {}
    for expected_role, email, password in DEMO_USERS:
        data = _login(client, email, password)
        login_results[email] = {
            "expected_role": expected_role,
            "returned_profile_key": data["user"]["profile_key"],
            "returned_role_key": data["user"]["role_key"],
            "token_present": bool(data.get("token")),
        }
        tokens[email] = data["token"]

    admin_headers = {"Authorization": f"Bearer {tokens['admin@local.test']}"}
    bootstrap_response = client.get("/api/bootstrap", headers=admin_headers)
    bootstrap_response.raise_for_status()
    bootstrap_data = bootstrap_response.json()
    bootstrap_counts = {key: len(value) for key, value in bootstrap_data.items()}

    formador_headers = {"Authorization": f"Bearer {tokens['formador1@local.test']}"}
    attendance_sessions_response = client.get("/api/trainer/attendance/sessions", headers=formador_headers)
    attendance_sessions_response.raise_for_status()
    attendance_sessions = attendance_sessions_response.json()

    first_session_id = attendance_sessions[0]["virtual_session_id"]
    qr_response = client.get(f"/api/trainer/attendance/sessions/{first_session_id}/qr", headers=formador_headers)
    qr_response.raise_for_status()
    qr_rows = qr_response.json()

    expected_people_response = client.get(
        f"/api/trainer/attendance/sessions/{first_session_id}/expected-people",
        headers=formador_headers,
    )
    expected_people_response.raise_for_status()

    public_qr_token = next(row["qr_token"] for row in qr_rows if row["qr_type"] == "ASISTENCIA")
    public_qr_response = client.get(f"/api/public/qr/{public_qr_token}")
    public_qr_response.raise_for_status()

    records_response = client.get(
        f"/api/trainer/attendance/sessions/{first_session_id}/records",
        headers=formador_headers,
    )
    records_response.raise_for_status()
    records_payload = records_response.json()

    result = {
        "health": health_response.json(),
        "login_results": login_results,
        "bootstrap_counts": bootstrap_counts,
        "critical_bootstrap_non_empty": {
            key: bootstrap_counts[key] > 0
            for key in ["campaigns", "activities", "people", "groups", "planners", "virtualSessions"]
        },
        "attendance_validation": {
            "sessions_total": len(attendance_sessions),
            "first_session_id": first_session_id,
            "qr_codes_total": len(qr_rows),
            "expected_people_total": len(expected_people_response.json()),
            "records_total": len(records_payload["records"]),
            "public_qr_status": public_qr_response.json()["access_status"],
        },
    }

    print(json.dumps(result, indent=2, ensure_ascii=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
