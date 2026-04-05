from fastapi import HTTPException
from pymysql import MySQLError

from app.database.connection import get_connection
from app.database.resources import WRITE_PROCEDURES


def _consume_results(cursor):
    rows = []
    if cursor.description:
        rows = cursor.fetchall()

    while cursor.nextset():
        if cursor.description:
            rows = cursor.fetchall()

    return rows


def execute_write(resource: str, action: str, params: list):
    procedures = WRITE_PROCEDURES.get(resource)
    if not procedures or action not in procedures:
        raise HTTPException(status_code=500, detail=f"Write action '{action}' for '{resource}' is not configured.")

    procedure = procedures[action]
    placeholders = ", ".join(["%s"] * len(params))
    sql = f"CALL {procedure}({placeholders})" if params else f"CALL {procedure}()"

    try:
        with get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql, params)
                result = _consume_results(cursor)
            connection.commit()
    except MySQLError as exc:
        raise HTTPException(status_code=500, detail="No fue posible ejecutar el procedimiento almacenado.") from exc

    return result[0] if result else {"success": True}
