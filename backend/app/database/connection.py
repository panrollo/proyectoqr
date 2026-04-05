from contextlib import contextmanager

import pymysql
from pymysql.cursors import DictCursor

from app.config.settings import settings


@contextmanager
def get_connection():
    connection = pymysql.connect(
        host=settings.db_host,
        port=settings.db_port,
        user=settings.db_user,
        password=settings.db_password,
        database=settings.db_name,
        charset="utf8mb4",
        cursorclass=DictCursor,
        autocommit=False,
        connect_timeout=settings.db_connect_timeout,
    )
    try:
        yield connection
    finally:
        connection.close()
