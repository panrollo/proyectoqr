from fastapi import HTTPException
from pymysql import MySQLError

from app.database.connection import get_connection
from app.database.resources import READ_VIEWS


def _build_where_clause(config: dict, filters: dict | None):
    if not filters:
        return "", []

    clauses = []
    params = []
    allowed_filters = set(config.get("filters", []))
    if config.get("id"):
        allowed_filters.add(config["id"])

    for column, value in filters.items():
        if value is None:
            continue
        if allowed_filters and column not in allowed_filters:
            raise HTTPException(status_code=400, detail="Filtro no permitido para este recurso.")
        clauses.append(f"{column} = %s")
        params.append(value)

    if not clauses:
        return "", []

    return " WHERE " + " AND ".join(clauses), params


def fetch_all(resource: str, filters: dict | None = None):
    config = READ_VIEWS.get(resource)
    if not config:
        raise HTTPException(status_code=500, detail=f"Read resource '{resource}' is not configured.")

    where_clause, params = _build_where_clause(config, filters)
    query = f"SELECT * FROM {config['view']}{where_clause}"
    if config.get("order_by"):
        query += f" ORDER BY {config['order_by']}"

    try:
        with get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(query, params)
                rows = cursor.fetchall()
    except MySQLError as exc:
        raise HTTPException(status_code=500, detail="No fue posible consultar la base de datos.") from exc

    return rows


def fetch_one(resource: str, resource_id: int):
    config = READ_VIEWS.get(resource)
    if not config:
        raise HTTPException(status_code=500, detail=f"Read resource '{resource}' is not configured.")

    rows = fetch_all(resource, {config["id"]: resource_id})
    if not rows:
        raise HTTPException(status_code=404, detail=f"{resource} record was not found.")
    return rows[0]
