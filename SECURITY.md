# Security Policy / Política de seguridad

## English

### Supported versions

Only the latest `master` is supported.

### Reporting a vulnerability

Do not open public issues for security problems. Report them privately through GitHub Security Advisories: open the Security tab and click "Report a vulnerability", or go directly to
https://github.com/jparga/py4web-docker-with-example-caddy/security/advisories/new

We acknowledge reports within 7 days.

### Past incidents

Until this release the repository tracked py4web runtime files (`apps/.service/session.secret` and SQLite databases). They have been removed and are now git-ignored. The session secret is regenerated on first start, so the leaked value is invalid for any new deployment.

If you deployed an earlier version, delete `apps/.service/session.secret` and restart; users will be logged out. The git history was intentionally not rewritten.

## Español

### Versiones soportadas

Solo se da soporte a la última versión de `master`.

### Cómo informar de una vulnerabilidad

No abras issues públicos para problemas de seguridad. Infórmanos en privado mediante GitHub Security Advisories: entra en la pestaña Security y pulsa "Report a vulnerability", o ve directamente a
https://github.com/jparga/py4web-docker-with-example-caddy/security/advisories/new

Acusamos recibo en un plazo de 7 días.

### Incidentes previos

Hasta esta versión el repositorio incluía ficheros de ejecución de py4web (`apps/.service/session.secret` y bases de datos SQLite). Se han eliminado y ahora están en `.gitignore`. El secreto de sesión se regenera en el primer arranque, así que el valor filtrado no es válido en ningún despliegue nuevo.

Si desplegaste una versión anterior, borra `apps/.service/session.secret` y reinicia; se cerrará la sesión de los usuarios. El historial de git no se ha reescrito de forma deliberada.
