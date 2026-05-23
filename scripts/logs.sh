#!/bin/bash
# Liat logs Bunskii (Hermes Agent)

cd "$(dirname "$0")/.."

SERVICE=${1:-hermes}

echo "📋 Logs for: $SERVICE"
echo "   (Ctrl+C buat keluar)"
echo "───────────────────────────────"

docker compose logs -f --tail=100 "$SERVICE"
