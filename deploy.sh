#!/bin/bash
# Script de despliegue automático para py4web-docker

set -e

PROJECT_DIR="/opt/py4web-docker"

echo "➡️  Entrando en $PROJECT_DIR"
cd $PROJECT_DIR

echo "⬇️  Actualizando código desde Git..."
git pull origin main

echo "🐳 Reconstruyendo y levantando contenedores..."
docker compose up -d --build

echo "✅ Despliegue completado con éxito."
