"""Shared fixtures / Fixtures compartidos: database, session and logger."""

import logging
import os
import sys

from py4web import DAL, Session

from . import settings

os.makedirs(settings.DB_FOLDER, exist_ok=True)

logger = logging.getLogger("py4web:" + settings.APP_NAME)
if not logger.handlers:
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(logging.Formatter("%(asctime)s %(levelname)s %(name)s %(message)s"))
    logger.addHandler(handler)
logger.setLevel(settings.LOG_LEVEL)

db = DAL(
    settings.DB_URI,
    folder=settings.DB_FOLDER,
    pool_size=settings.DB_POOL_SIZE,
    migrate=settings.DB_MIGRATE,
    fake_migrate=False,
    decode_credentials=True,  # settings.py URL-encodes user and password
)

# Signed cookie session; the secret comes from apps/.service/session.secret.
# The Secure flag follows X-Forwarded-Proto, which Caddy sets.
# Sesión en cookie firmada; el secreto sale de apps/.service/session.secret.
# El flag Secure sigue a X-Forwarded-Proto, que envía Caddy.
session = Session(same_site="Lax")
