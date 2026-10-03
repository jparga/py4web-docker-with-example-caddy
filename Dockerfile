# syntax=docker/dockerfile:1
FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN useradd --create-home --uid 1000 py4web

WORKDIR /home/py4web

# Pure-Python dependencies only (PyMySQL): no compiler or system packages needed.
# Solo dependencias Python puras (PyMySQL): no hace falta compilador ni paquetes del sistema.
COPY requirements.txt .
RUN pip install -r requirements.txt

USER 1000:1000

# System apps from the installed py4web, minus the ones not needed in production.
# Apps de sistema del py4web instalado, quitando las que no hacen falta en producción.
RUN py4web setup --yes apps \
    && rm -rf apps/_documentation apps/_minimal apps/_scaffold apps/showcase

COPY --chown=py4web:py4web apps/example_app apps/example_app
# Created here so the named volume mounted on it inherits py4web ownership.
# Se crea aquí para que el volumen montado encima herede el propietario py4web.
RUN mkdir -p apps/example_app/databases
COPY --chmod=0755 docker/entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/example_app/health', timeout=4)"]

ENTRYPOINT ["entrypoint.sh"]
