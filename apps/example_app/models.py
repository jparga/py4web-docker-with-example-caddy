"""Database tables / Tablas de la base de datos."""

import datetime

from pydal.validators import IS_DATETIME

from .common import db

# Anonymous page-view counter: no IP, no user agent, no personal data.
# Contador anónimo de visitas: sin IP, sin user agent, sin datos personales.
db.define_table(
    "page_view",
    db.Field(
        "viewed_on",
        "datetime",
        default=lambda: datetime.datetime.now(datetime.UTC),
        requires=IS_DATETIME(),
        writable=False,
    ),
)

db.commit()
