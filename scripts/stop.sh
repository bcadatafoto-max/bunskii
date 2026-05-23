#!/bin/bash
# Stop Bunskii (semua containers)

set -e
cd "$(dirname "$0")/.."

echo "🛑 Stopping Bunskii..."
docker compose down

echo "✅ Bunskii stopped."
echo "   Data & skills tetap tersimpan (persistent volumes)."
echo "   Jalanin ./scripts/start.sh kapan aja buat start lagi."
