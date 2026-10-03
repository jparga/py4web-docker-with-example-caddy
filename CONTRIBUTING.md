# Contributing

**English** | [Español](CONTRIBUTING.es.md)

Thanks for helping improve this project.

## Reporting issues

- Use the [issue templates](https://github.com/jparga/py4web-docker-with-example-caddy/issues/new/choose) for bugs and feature requests.
- Security problems must NOT go in public issues: see [SECURITY.md](SECURITY.md).

## Workflow

1. Fork the repository and create a branch from `master` with a prefix: `feat/`, `fix/`, `docs/` or `chore/` (for example `fix/healthcheck-timeout`).
2. Write commits following [Conventional Commits](https://www.conventionalcommits.org) (`feat: ...`, `fix: ...`, `docs: ...`, `chore: ...`).
3. Open a pull request against `master`.

## Checks

Install and run the pre-commit hooks (gitleaks, ruff, ruff-format, shellcheck, hadolint, YAML checks):

```bash
pre-commit install
pre-commit run --all-files
```

Test locally before opening the PR:

```bash
pip install pytest && pytest -q tests
tests/fail2ban/test_filters.sh
docker compose up -d --build --wait
curl http://localhost/example_app/health
```

## Rules

- Never commit secrets (`.env`, keys, certificates, `settings_private.py`).
- Documentation changes must update both languages (`README.md` and `README.es.md`, `CONTRIBUTING.md` and `CONTRIBUTING.es.md`).

By contributing you agree that your work is released under the [MIT license](LICENSE) and that you follow the [Code of Conduct](CODE_OF_CONDUCT.md).
