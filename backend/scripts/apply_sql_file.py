import argparse
import sys
from pathlib import Path

import pymysql


def parse_sql_statements(content: str) -> list[str]:
    statements: list[str] = []
    delimiter = ";"
    buffer: list[str] = []

    for raw_line in content.splitlines():
        line = raw_line.rstrip("\n")
        stripped = line.strip()

        if not stripped:
            buffer.append(line)
            continue

        if stripped.startswith("--") or stripped.startswith("#"):
            continue

        if stripped.upper().startswith("DELIMITER "):
            if "".join(buffer).strip():
                statement = "\n".join(buffer).strip()
                if statement:
                    statements.append(statement)
            buffer = []
            delimiter = stripped.split(None, 1)[1]
            continue

        buffer.append(line)
        current = "\n".join(buffer)
        if current.rstrip().endswith(delimiter):
            statement = current.rstrip()
            statement = statement[: -len(delimiter)].strip()
            if statement:
                statements.append(statement)
            buffer = []

    if "".join(buffer).strip():
        statement = "\n".join(buffer).strip()
        if statement:
            statements.append(statement)

    return statements


def main() -> int:
    parser = argparse.ArgumentParser(description="Apply a SQL file with DELIMITER support using PyMySQL.")
    parser.add_argument("sql_file", type=Path)
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=3306)
    parser.add_argument("--user", required=True)
    parser.add_argument("--password", default="")
    parser.add_argument("--database", default=None)
    parser.add_argument("--charset", default="utf8mb4")
    parser.add_argument("--ignore-error-codes", default="")
    args = parser.parse_args()

    sql_path = args.sql_file.resolve()
    content = sql_path.read_text(encoding="utf-8")
    statements = parse_sql_statements(content)
    ignored_codes = {
        int(code.strip())
        for code in args.ignore_error_codes.split(",")
        if code.strip()
    }

    connection = pymysql.connect(
        host=args.host,
        port=args.port,
        user=args.user,
        password=args.password,
        database=args.database,
        charset=args.charset,
        autocommit=True,
        cursorclass=pymysql.cursors.DictCursor,
        client_flag=pymysql.constants.CLIENT.MULTI_STATEMENTS,
    )

    try:
        with connection.cursor() as cursor:
            for index, statement in enumerate(statements, start=1):
                try:
                    cursor.execute(statement)
                    while cursor.nextset():
                        pass
                except Exception as exc:
                    mysql_code = exc.args[0] if getattr(exc, "args", None) else None
                    if isinstance(mysql_code, int) and mysql_code in ignored_codes:
                        print(f"Ignored MySQL error {mysql_code} at statement #{index} from {sql_path}")
                        continue
                    print(f"Failed at statement #{index} from {sql_path}", file=sys.stderr)
                    print(statement[:1000], file=sys.stderr)
                    raise exc
    finally:
        connection.close()

    print(f"Applied {len(statements)} statements from {sql_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
