import json
import sys
from pathlib import Path


CURRENT_FILE = Path(__file__).resolve()
BACKEND_DIR = CURRENT_FILE.parents[1]
sys.path.insert(0, str(BACKEND_DIR))

from app.database.connection import get_connection
from app.services.qr_service import build_public_qr_url


def main() -> int:
    updated_rows: list[dict] = []

    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute(
                """
                SELECT id_sesion_virtual_qr, qr_token, public_url
                FROM sesion_virtual_qr
                WHERE qr_token IS NOT NULL
                  AND qr_token <> ''
                ORDER BY id_sesion_virtual_qr
                """
            )
            rows = cursor.fetchall()

            for row in rows:
                canonical_url = build_public_qr_url(row["qr_token"])
                if (row.get("public_url") or "").strip() == canonical_url:
                    continue

                cursor.execute(
                    """
                    UPDATE sesion_virtual_qr
                    SET public_url = %s,
                        actualizado_en = NOW()
                    WHERE id_sesion_virtual_qr = %s
                    """,
                    (canonical_url, row["id_sesion_virtual_qr"]),
                )
                updated_rows.append(
                    {
                        "session_qr_id": row["id_sesion_virtual_qr"],
                        "previous_public_url": row.get("public_url"),
                        "new_public_url": canonical_url,
                    }
                )
        connection.commit()

    print(
        json.dumps(
            {
                "status": "ok",
                "updated_total": len(updated_rows),
                "updated_rows": updated_rows,
            },
            indent=2,
            ensure_ascii=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
