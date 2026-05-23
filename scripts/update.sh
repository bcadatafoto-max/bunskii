#!/bin/bash
# Update Hermes Agent ke versi terbaru

set -e
cd "$(dirname "$0")/.."

echo "🔄 Updating Bunskii..."
echo ""

# Pull latest images
echo "📥 Pulling latest images..."
docker compose pull

# Restart with new images
echo "🔄 Restarting services..."
docker compose up -d

echo ""
echo "✅ Bunskii updated!"
echo "   Cek versi: docker compose exec hermes hermes --version"
