#!/bin/sh
# Container entrypoint for py4web / Punto de entrada del contenedor py4web.
set -eu

APPS_DIR="${PY4WEB_APPS_DIR:-/home/py4web/apps}"
PASSWORD_FILE="$APPS_DIR/.service/password.txt"
DASHBOARD_MODE="${PY4WEB_DASHBOARD_MODE:-none}"
LOGGING_LEVEL="${PY4WEB_LOGGING_LEVEL:-20}"

# Both values are interpolated into Python code below: accept known values only.
# Ambos valores se interpolan en código Python más abajo: solo se aceptan valores conocidos.
case "$DASHBOARD_MODE" in
    none | readonly | full) ;;
    *) echo "Invalid PY4WEB_DASHBOARD_MODE: $DASHBOARD_MODE (none|readonly|full)" >&2; exit 1 ;;
esac
case "$LOGGING_LEVEL" in
    '' | *[!0-9]*) echo "Invalid PY4WEB_LOGGING_LEVEL: $LOGGING_LEVEL (0-50)" >&2; exit 1 ;;
esac

mkdir -p "$APPS_DIR/.service"

# The dashboard is disabled unless a mode and a password are both provided.
# El dashboard queda desactivado salvo que se indiquen modo y contraseña.
if [ "$DASHBOARD_MODE" != "none" ]; then
    if [ -z "${PY4WEB_DASHBOARD_PASSWORD:-}" ]; then
        echo "PY4WEB_DASHBOARD_MODE=$DASHBOARD_MODE requires PY4WEB_DASHBOARD_PASSWORD" >&2
        exit 1
    fi
    py4web set_password --password "$PY4WEB_DASHBOARD_PASSWORD" --password_file "$PASSWORD_FILE" >/dev/null
fi

# Load the apps once so PyDAL migrations run in a single process; otherwise every
# gunicorn worker races to create the same tables ("Table ... already exists").
# Carga las apps una vez para que las migraciones de PyDAL corran en un solo proceso;
# si no, cada worker de gunicorn compite por crear las mismas tablas.
python -c "from py4web.core import wsgi; wsgi(apps_folder='$APPS_DIR', dashboard_mode='none', password_file='$PASSWORD_FILE', logging_level=$LOGGING_LEVEL)"

# gunicorn is started directly on py4web's WSGI factory: "py4web run --server gunicorn"
# fails in py4web 1.20260805 ("No configuration setting for: reloader").
# Se arranca gunicorn directamente sobre la factoría WSGI de py4web: "py4web run --server
# gunicorn" falla en py4web 1.20260805 ("No configuration setting for: reloader").
# --forwarded-allow-ips='*' trusts X-Forwarded-* from Caddy; only reachable on the internal network.
exec gunicorn \
    --bind 0.0.0.0:8000 \
    --workers "${PY4WEB_WORKERS:-2}" \
    --forwarded-allow-ips='*' \
    --access-logfile - \
    "py4web.core:wsgi(apps_folder='$APPS_DIR', dashboard_mode='$DASHBOARD_MODE', password_file='$PASSWORD_FILE', logging_level=$LOGGING_LEVEL)"
