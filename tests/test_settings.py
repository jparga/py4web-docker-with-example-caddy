"""Unit tests for apps/example_app/settings.py (stdlib only, no py4web needed)."""

import importlib.util
from pathlib import Path
from urllib.parse import unquote

import pytest

SETTINGS = Path(__file__).resolve().parents[1] / "apps" / "example_app" / "settings.py"
DB_VARS = ("DB_URI", "DB_HOST", "DB_PORT", "MYSQL_USER", "MYSQL_PASSWORD", "MYSQL_DATABASE")


def load_settings():
    spec = importlib.util.spec_from_file_location("example_app_settings", SETTINGS)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


@pytest.fixture(autouse=True)
def clean_env(monkeypatch):
    for name in DB_VARS:
        monkeypatch.delenv(name, raising=False)


def test_sqlite_fallback_without_mysql_vars():
    assert load_settings().DB_URI == "sqlite://storage.db"


def test_mysql_uri_from_environment(monkeypatch):
    monkeypatch.setenv("MYSQL_USER", "app")
    monkeypatch.setenv("MYSQL_PASSWORD", "secret")
    monkeypatch.setenv("MYSQL_DATABASE", "py4web")
    assert load_settings().DB_URI == (
        "mysql:pymysql://app:secret@db:3306/py4web?set_encoding=utf8mb4"
    )


@pytest.mark.parametrize("password", ["a/b+c=", "p@ss:w#rd", "x%y?z&"])
def test_mysql_password_is_url_encoded(monkeypatch, password):
    # openssl rand -base64 produces "/", "+" and "="; "@" or ":" would break the URI.
    monkeypatch.setenv("MYSQL_USER", "app")
    monkeypatch.setenv("MYSQL_PASSWORD", password)
    monkeypatch.setenv("MYSQL_DATABASE", "py4web")
    uri = load_settings().DB_URI
    credentials = uri.removeprefix("mysql:pymysql://").rsplit("@", 1)[0]
    user, encoded = credentials.split(":", 1)
    assert "@" not in encoded and ":" not in encoded and "/" not in encoded
    assert (unquote(user), unquote(encoded)) == ("app", password)


def test_db_uri_overrides_mysql_vars(monkeypatch):
    monkeypatch.setenv("MYSQL_USER", "app")
    monkeypatch.setenv("MYSQL_PASSWORD", "secret")
    monkeypatch.setenv("MYSQL_DATABASE", "py4web")
    monkeypatch.setenv("DB_URI", "sqlite://other.db")
    assert load_settings().DB_URI == "sqlite://other.db"


def test_custom_host_and_port(monkeypatch):
    monkeypatch.setenv("MYSQL_USER", "app")
    monkeypatch.setenv("MYSQL_PASSWORD", "secret")
    monkeypatch.setenv("MYSQL_DATABASE", "py4web")
    monkeypatch.setenv("DB_HOST", "mysql.internal")
    monkeypatch.setenv("DB_PORT", "3307")
    assert "@mysql.internal:3307/" in load_settings().DB_URI
