"""
Application settings / Configuración de la aplicación.

Every value is read from the environment so that no secret is ever committed.
Todos los valores se leen del entorno para no versionar ningún secreto.

Optional local overrides go in ``settings_private.py`` (git-ignored).
Los ajustes locales opcionales van en ``settings_private.py`` (ignorado por git).
"""

import os
from urllib.parse import quote

APP_FOLDER = os.path.dirname(__file__)
APP_NAME = os.path.split(APP_FOLDER)[-1]


def _mysql_uri():
    """Build a PyDAL MySQL URI from the variables shared with the db service."""
    user = quote(os.environ["MYSQL_USER"], safe="")
    password = quote(os.environ["MYSQL_PASSWORD"], safe="")
    host = os.environ.get("DB_HOST", "db")
    port = os.environ.get("DB_PORT", "3306")
    name = os.environ["MYSQL_DATABASE"]
    return f"mysql:pymysql://{user}:{password}@{host}:{port}/{name}?set_encoding=utf8mb4"


# DB_URI wins if set; otherwise MySQL when configured, else a local SQLite file.
# DB_URI tiene prioridad; si no, MySQL cuando está configurado, o SQLite local.
if os.environ.get("DB_URI"):
    DB_URI = os.environ["DB_URI"]
elif os.environ.get("MYSQL_USER"):
    DB_URI = _mysql_uri()
else:
    DB_URI = "sqlite://storage.db"

DB_FOLDER = os.path.join(APP_FOLDER, "databases")
DB_POOL_SIZE = int(os.environ.get("DB_POOL_SIZE", "5"))
DB_MIGRATE = os.environ.get("DB_MIGRATE", "true").lower() == "true"

LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO")

try:
    from .settings_private import *  # noqa: F401,F403
except ImportError:
    pass
