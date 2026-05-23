#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# BUNSKII Installer — Hermes Agent for Linux VPS (Ubuntu 22.04)
# Untuk OrangeVPS / Hetzner / Vultr / dll
# ═══════════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════╗"
echo "║       🤖 BUNSKII — Hermes Agent Setup       ║"
echo "║       Linux VPS Edition (Ubuntu/Debian)      ║"
echo "╠══════════════════════════════════════════════╣"
echo "║  Telegram Bot + Cloudflare Tunnel + LLM API ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# ─── Check OS ───────────────────────────────────────────────
check_os() {
    if [[ "$(uname)" != "Linux" ]]; then
        echo -e "${RED}[ERROR] Script ini khusus Linux. Kalo lo pake macOS, jalanin install.sh${NC}"
        exit 1
    fi
    echo -e "${GREEN}[OK] Linux detected: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2)${NC}"
}

# ─── Setup Swap (penting buat VPS 4GB) ─────────────────────
setup_swap() {
    echo -e "\n${BLUE}[1/5] Setting up swap (4GB)...${NC}"
    if [[ -f /swapfile ]]; then
        echo -e "${GREEN}Swap sudah ada ✅${NC}"
        return
    fi

    sudo fallocate -l 4G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab > /dev/null
    echo -e "${GREEN}Swap 4GB created ✅${NC}"
}

# ─── Install Docker ─────────────────────────────────────────
install_docker() {
    echo -e "\n${BLUE}[2/5] Installing Docker...${NC}"
    if command -v docker &> /dev/null; then
        echo -e "${GREEN}Docker already installed ✅${NC}"
        return
    fi

    # Install Docker via official script
    curl -fsSL https://get.docker.com | sudo sh

    # Add current user to docker group
    sudo usermod -aG docker "$USER"

    # Start Docker
    sudo systemctl enable docker
    sudo systemctl start docker

    echo -e "${GREEN}Docker installed ✅${NC}"
    echo -e "${YELLOW}[NOTE] Lo mungkin perlu logout/login ulang biar docker jalan tanpa sudo.${NC}"
}

# ─── Install Docker Compose ─────────────────────────────────
install_compose() {
    echo -e "\n${BLUE}[3/5] Checking Docker Compose...${NC}"
    if docker compose version &> /dev/null 2>&1; then
        echo -e "${GREEN}Docker Compose available ✅${NC}"
    else
        echo -e "${CYAN}Installing Docker Compose plugin...${NC}"
        sudo apt-get update
        sudo apt-get install -y docker-compose-plugin
        echo -e "${GREEN}Docker Compose installed ✅${NC}"
    fi
}

# ─── Check .env ─────────────────────────────────────────────
check_env() {
    echo -e "\n${BLUE}[4/5] Checking .env configuration...${NC}"
    if [[ ! -f ".env" ]]; then
        cp .env.example .env
        echo -e "${RED}╔══════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║  PENTING: Isi file .env dulu sebelum lanjut!    ║${NC}"
        echo -e "${RED}║                                                  ║${NC}"
        echo -e "${RED}║  Minimal yang WAJIB diisi:                      ║${NC}"
        echo -e "${RED}║  1. TELEGRAM_BOT_TOKEN                          ║${NC}"
        echo -e "${RED}║  2. TELEGRAM_ALLOWED_USERS                      ║${NC}"
        echo -e "${RED}║  3. OPENROUTER_API_KEY atau GOOGLE_API_KEY      ║${NC}"
        echo -e "${RED}║  4. CLOUDFLARE_TUNNEL_TOKEN                     ║${NC}"
        echo -e "${RED}║  5. DOMAIN                                      ║${NC}"
        echo -e "${RED}╚══════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${CYAN}Edit .env: ${NC}nano .env"
        echo ""
        read -p "Tekan ENTER kalo .env udah lo isi..."
    fi
    echo -e "${GREEN}.env exists ✅${NC}"
}

# ─── Start Services ─────────────────────────────────────────
start_services() {
    echo -e "\n${BLUE}[5/5] Starting Hermes Agent...${NC}"

    mkdir -p workspace

    echo -e "${CYAN}Pulling Docker images...${NC}"
    docker compose pull

    echo -e "${CYAN}Starting containers...${NC}"
    docker compose up -d

    echo -e "${GREEN}Hermes Agent started! ✅${NC}"
}

# ─── Summary ────────────────────────────────────────────────
summary() {
    source .env 2>/dev/null || true
    echo -e "\n${GREEN}"
    echo "╔══════════════════════════════════════════════════╗"
    echo "║         🎉 BUNSKII IS READY ON VPS!             ║"
    echo "╠══════════════════════════════════════════════════╣"
    echo "║  Telegram: Buka bot lo, kirim pesan             ║"
    echo "║  Dashboard: https://${DOMAIN:-bunskii.biz.id}   ║"
    echo "║  24/7 running, gak perlu laptop nyala           ║"
    echo "╠══════════════════════════════════════════════════╣"
    echo "║  ./scripts/start.sh  - Start                    ║"
    echo "║  ./scripts/stop.sh   - Stop                     ║"
    echo "║  ./scripts/logs.sh   - Logs                     ║"
    echo "║  ./scripts/update.sh - Update                   ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# ─── Main ───────────────────────────────────────────────────
main() {
    check_os
    setup_swap
    install_docker
    install_compose
    check_env
    start_services
    summary
}

main "$@"
