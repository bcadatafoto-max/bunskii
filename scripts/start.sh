#!/bin/bash
# Start Bunskii (Hermes Agent + Caddy + Tunnel)

set -e
cd "$(dirname "$0")/.."

echo "🚀 Starting Bunskii..."

# Check Docker
if ! docker info &> /dev/null 2>&1; then
    echo "❌ Docker belum running. Buka Docker Desktop dulu."
    exit 1
fi

# Start services
docker compose up -d

echo ""
echo "✅ Bunskii is running!"
echo ""
echo "📱 Buka Telegram → chat ke bot lo"
echo "🌐 Dashboard: https://$(grep DOMAIN .env 2>/dev/null | cut -d= -f2 || echo 'localhost')"
echo ""
echo "Commands:"
echo "  ./scripts/logs.sh    - Liat logs"
echo "  ./scripts/stop.sh    - Stop semua"
