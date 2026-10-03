"""HTTP endpoints / Endpoints HTTP."""

from py4web import action, response

from . import settings
from .common import db, logger, session


@action("index")
@action.uses("index.html", db, session)
def index():
    db.page_view.insert()
    return dict(
        views=db(db.page_view).count(),
        backend=settings.DB_URI.split(":", 1)[0],
    )


@action("health")
@action.uses(db)
def health():
    """Liveness + database check used by the Docker healthcheck."""
    try:
        db.executesql("SELECT 1")
    except Exception:  # noqa: BLE001 - any DB failure means unhealthy
        logger.exception("healthcheck: database unreachable")
        response.status = 503
        return dict(status="error")
    return dict(status="ok")
