import sys
from pathlib import Path


CURRENT_FILE = Path(__file__).resolve()
BACKEND_DIR = CURRENT_FILE.parents[1]
sys.path.insert(0, str(BACKEND_DIR))

from app.services.admin_bootstrap_service import format_json, verify_database_connection


def main() -> int:
    try:
        print(format_json(verify_database_connection()))
    except Exception as exc:
        print(str(exc), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
