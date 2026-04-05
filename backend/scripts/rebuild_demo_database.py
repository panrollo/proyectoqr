import os
import subprocess
import sys
from pathlib import Path


CURRENT_FILE = Path(__file__).resolve()
BACKEND_DIR = CURRENT_FILE.parents[1]
PROJECT_DIR = BACKEND_DIR.parent
sys.path.insert(0, str(BACKEND_DIR))

from app.config.settings import settings


BASE_SQL = PROJECT_DIR / "base de datos pryecto formadores.txt"
FOLLOW_UP_SQL = [
    BACKEND_DIR / "sql" / "qr_schema_updates.sql",
    BACKEND_DIR / "sql" / "normalizacion_lecturas.sql",
    BACKEND_DIR / "sql" / "stored_procedures_write.sql",
    BACKEND_DIR / "sql" / "seed_demo_operativa.sql",
]


def run_sql_file(sql_file: Path, database: str | None, ignore_error_codes: str = "") -> None:
    command = [
        sys.executable,
        str(BACKEND_DIR / "scripts" / "apply_sql_file.py"),
        str(sql_file),
        "--host",
        settings.db_host,
        "--port",
        str(settings.db_port),
        "--user",
        settings.db_user,
        "--password",
        settings.db_password,
    ]
    if database:
        command.extend(["--database", database])
    if ignore_error_codes:
        command.extend(["--ignore-error-codes", ignore_error_codes])

    subprocess.run(command, check=True, cwd=str(PROJECT_DIR), env=os.environ.copy())


def main() -> int:
    run_sql_file(BASE_SQL, None, ignore_error_codes="1054,1060,1061,1068,1091,1826")
    for sql_file in FOLLOW_UP_SQL:
        run_sql_file(sql_file, settings.db_name)
    print("Database schema and demo seed applied successfully.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
