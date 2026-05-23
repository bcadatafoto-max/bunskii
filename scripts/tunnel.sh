#!/bin/bash
# Manage Cloudflare Tunnel (troubleshooting & status)

cd "$(dirname "$0")/.."

case "${1:-status}" in
    status)
        echo "🌐 Cloudflare Tunnel Status:"
        docker compose logs --tail=20 cloudflared
        ;;
    restart)
        echo "🔄 Restarting tunnel..."
        docker compose restart cloudflared
        echo "✅ Tunnel restarted"
        ;;
    test)
        source .env 2>/dev/null
        echo "🧪 Testing connection to https://${DOMAIN}..."
        if curl -sf "https://${DOMAIN}/health" > /dev/null 2>&1; then
            echo "✅ Tunnel is working! HTTPS accessible."
        else
            echo "❌ Tunnel not reachable. Check:"
            echo "   1. CLOUDFLARE_TUNNEL_TOKEN di .env udah bener?"
            echo "   2. DNS record di Cloudflare udah di-set?"
            echo "   3. Run: ./scripts/logs.sh cloudflared"
        fi
        ;;
    *)
        echo "Usage: $0 {status|restart|test}"
        ;;
esac
