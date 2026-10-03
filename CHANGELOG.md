# Changelog

> Nota: este changelog se mantiene en inglés.

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- `example_app`: MySQL via environment variables, `/health` endpoint and anonymous page-view counter.
- `.env.example`.
- `docker/entrypoint.sh`.
- Healthchecks.
- CI workflow (lint + end-to-end smoke test).
- Dependabot.
- pre-commit.
- Issue and PR templates.
- Bilingual (English/Spanish) docs.
- `SECURITY.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`.
- Unit tests for `settings.py` (pytest) and Fail2Ban filter test.
- `CODEOWNERS`.

### Changed

- Dockerfile on `python:3.13-slim` with PyMySQL (no compiler), gunicorn server and pinned versions.
- Caddyfile is a single file driven by `DOMAIN`, with security headers and JSON logs.
- Compose: secrets from `.env`, internal `backend` network, pinned images (caddy 2.11, mysql 9.7 LTS, fail2ban 1.1.1), Fail2Ban behind the `fail2ban` profile.
- `deploy.sh`: relative path, branch argument, fast-forward only.

### Removed

- Vendored copies of `_dashboard`, `_default` and `_scaffold` (now installed by `py4web setup` at build time).
- `Dockerfile.py4web` (replaced by `Dockerfile`).
- `py4web-start.py`.
- `Caddyfile.local`.
- `mysql/init.sql`.
- Old Fail2Ban `jail.local` and filters.

### Security

- Removed the tracked session secret and databases (see [SECURITY.md](SECURITY.md)).
- MySQL passwords are no longer hardcoded.

### Fixed

- MySQL pinned to the 9.7 LTS line; a Dependabot bump had moved it to the 26.7 innovation release. Volumes initialised with 26.7 cannot be downgraded: recreate them (`docker compose down -v`) or keep 26.x.
- `deploy.sh` pulled a non-existent `main` branch.
- gunicorn workers raced to run PyDAL migrations on MySQL ("Table already exists"), leaving the app unloaded in some workers; migrations now run once before the workers start.
- MySQL passwords with URL-reserved characters (e.g. from `openssl rand -base64`) broke the connection URI.
- Fail2Ban could never ban: logs were not shared, wrong log format, wrong config path, and the `INPUT` chain was used instead of `DOCKER-USER`.
