import json
from typing import Any

from pymysql import MySQLError

from app.database.connection import get_connection
from app.utils.security import generate_qr_code, hash_password


def _consume_results(cursor) -> list[dict[str, Any]]:
    rows = []
    if cursor.description:
        rows = cursor.fetchall()

    while cursor.nextset():
        if cursor.description:
            rows = cursor.fetchall()

    return rows


def _fetch_scalar(cursor, query: str, params: list[Any] | None = None) -> Any:
    cursor.execute(query, params or [])
    row = cursor.fetchone()
    if not row:
        return None
    return next(iter(row.values()))


def _fetch_role(cursor) -> dict[str, Any] | None:
    cursor.execute(
        """
        SELECT id_rol, nombre, estado
        FROM roles
        WHERE LOWER(TRIM(nombre)) IN ('admin', 'superadmin')
        ORDER BY CASE
            WHEN LOWER(TRIM(nombre)) = 'admin' THEN 0
            ELSE 1
        END
        LIMIT 1
        """
    )
    return cursor.fetchone()


def _ensure_admin_role(cursor) -> dict[str, Any]:
    role = _fetch_role(cursor)
    if role:
        return {
            "role_id": role["id_rol"],
            "role_key": role["nombre"],
            "role_status": role["estado"],
            "role_action": "reused",
        }

    cursor.execute("INSERT INTO roles (nombre, estado) VALUES (%s, %s)", ["admin", 1])
    return {
        "role_id": cursor.lastrowid,
        "role_key": "admin",
        "role_status": 1,
        "role_action": "created",
    }


def _find_user_by_email(cursor, email: str) -> dict[str, Any] | None:
    cursor.execute(
        """
        SELECT id_usuario, nombre_completo, correo, id_rol, estado
        FROM usuarios
        WHERE LOWER(TRIM(correo)) = %s
        LIMIT 1
        """,
        [email.strip().lower()],
    )
    return cursor.fetchone()


def _call_procedure(cursor, procedure: str, params: list[Any]) -> list[dict[str, Any]]:
    placeholders = ", ".join(["%s"] * len(params))
    sql = f"CALL {procedure}({placeholders})" if params else f"CALL {procedure}()"
    cursor.execute(sql, params)
    return _consume_results(cursor)


def verify_database_connection() -> dict[str, Any]:
    try:
        with get_connection() as connection:
            with connection.cursor() as cursor:
                diagnostics = {
                    "database": _fetch_scalar(cursor, "SELECT DATABASE() AS database_name"),
                    "roles_total": _fetch_scalar(cursor, "SELECT COUNT(*) AS total FROM roles"),
                    "users_total": _fetch_scalar(cursor, "SELECT COUNT(*) AS total FROM usuarios"),
                    "auth_access_total": _fetch_scalar(cursor, "SELECT COUNT(*) AS total FROM vw_auth_access"),
                    "admin_procedure_exists": bool(
                        _fetch_scalar(
                            cursor,
                            """
                            SELECT COUNT(*) AS total
                            FROM information_schema.routines
                            WHERE routine_schema = DATABASE()
                              AND routine_type = 'PROCEDURE'
                              AND routine_name = 'sp_usuario_create'
                            """,
                        )
                    ),
                    "auth_view_exists": bool(
                        _fetch_scalar(
                            cursor,
                            """
                            SELECT COUNT(*) AS total
                            FROM information_schema.views
                            WHERE table_schema = DATABASE()
                              AND table_name = 'vw_auth_access'
                            """,
                        )
                    ),
                }
    except MySQLError as exc:
        raise RuntimeError("No fue posible conectarse a la base de datos configurada.") from exc

    diagnostics["status"] = "ok"
    return diagnostics


def ensure_admin_user(full_name: str, email: str, password: str) -> dict[str, Any]:
    normalized_name = full_name.strip()
    normalized_email = email.strip().lower()
    if not normalized_name or not normalized_email or not password:
        raise ValueError("Nombre, correo y contrasena del administrador son obligatorios.")

    try:
        with get_connection() as connection:
            with connection.cursor() as cursor:
                role = _ensure_admin_role(cursor)
                existing_user = _find_user_by_email(cursor, normalized_email)
                password_hash = hash_password(password)

                if existing_user:
                    rows = _call_procedure(
                        cursor,
                        "sp_usuario_update",
                        [
                            existing_user["id_usuario"],
                            normalized_name,
                            normalized_email,
                            password_hash,
                            role["role_id"],
                            1,
                        ],
                    )
                    action = "updated"
                else:
                    rows = _call_procedure(
                        cursor,
                        "sp_usuario_create",
                        [
                            normalized_name,
                            normalized_email,
                            password_hash,
                            role["role_id"],
                            generate_qr_code(),
                            1,
                        ],
                    )
                    action = "created"

            connection.commit()
    except MySQLError as exc:
        raise RuntimeError("No fue posible asegurar el usuario administrador en la base de datos.") from exc

    user = rows[0] if rows else None
    return {
        "status": "ok",
        "action": action,
        "role": role,
        "user": user,
    }


def format_json(data: dict[str, Any]) -> str:
    return json.dumps(data, indent=2, ensure_ascii=True, default=str)
