# Cómo contribuir

[English](CONTRIBUTING.md) | **Español**

Gracias por ayudar a mejorar este proyecto.

## Informar de problemas

- Usa las [plantillas de issues](https://github.com/jparga/py4web-docker-with-example-caddy/issues/new/choose) para errores y propuestas.
- Los problemas de seguridad NO deben ir en issues públicos: consulta [SECURITY.md](SECURITY.md).

## Flujo de trabajo

1. Haz un fork y crea una rama desde `master` con prefijo: `feat/`, `fix/`, `docs/` o `chore/` (por ejemplo `fix/healthcheck-timeout`).
2. Escribe los commits siguiendo [Conventional Commits](https://www.conventionalcommits.org/es/) (`feat: ...`, `fix: ...`, `docs: ...`, `chore: ...`).
3. Abre una pull request contra `master`.

## Comprobaciones

Instala y ejecuta los hooks de pre-commit (gitleaks, ruff, ruff-format, shellcheck, hadolint y validación de YAML):

```bash
pre-commit install
pre-commit run --all-files
```

Prueba en local antes de abrir la PR:

```bash
docker compose up -d --build --wait
curl http://localhost/example_app/health
```

## Normas

- No subas nunca secretos (`.env`, claves, certificados, `settings_private.py`).
- Los cambios de documentación deben actualizar ambos idiomas (`README.md` y `README.es.md`, `CONTRIBUTING.md` y `CONTRIBUTING.es.md`).

Al contribuir aceptas que tu trabajo se publique bajo la [licencia MIT](LICENSE) y que sigues el [Código de conducta](CODE_OF_CONDUCT.md).
