#!/usr/bin/env bash
# Pull the latest code and rebuild the stack.
# Descarga el último código y reconstruye el stack.
#
# Usage / Uso: ./deploy.sh [branch]   (default: master)
set -euo pipefail

BRANCH="${1:-master}"
cd "$(dirname "$(readlink -f "$0")")"

if [[ ! -f .env ]]; then
    echo "❌ .env not found. Copy .env.example to .env and fill it in." >&2
    exit 1
fi

echo "⬇️  Updating code from origin/${BRANCH}..."
git fetch origin "$BRANCH"
git merge --ff-only "origin/${BRANCH}"

echo "🐳 Pulling images and rebuilding containers..."
docker compose pull --ignore-buildable
docker compose up -d --build --remove-orphans --wait

echo "🧹 Removing dangling images..."
docker image prune -f

echo "✅ Deployment completed."
