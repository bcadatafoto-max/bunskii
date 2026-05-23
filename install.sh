#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# BUNSKII Installer — Hermes Agent for macOS (Apple Silicon)
# Optimized for MacBook M1/M2/M3 Pro/Max
# ═══════════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════╗"
echo "║       🤖 BUNSKII — Hermes Agent Setup       ║"
echo "║       MacBook M1 Pro Edition                 ║"
echo "╠══════════════════════════════════════════════╣"
echo "║  Telegram Bot + Cloudflare Tunnel + LLM API ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# ─── Check OS ───────────────────────────────────────────────
check_os() {
    if [[ "$(uname)" != "Darwin" ]]; then
        echo -e "${RED}[ERROR] Script ini khusus macOS. Kalo lo pake Linux VPS, jalanin install-linux.sh${NC}"
        exit 1
    fi
    
    ARCH=$(uname -m)
    if [[ "$ARCH" == "arm64" ]]; then
        echo -e "${GREEN}[OK] Apple Silicon detected (${ARCH}) ✅${NC}"
    else
        echo -e "${YELLOW}[WARN] Intel Mac detected. Masih bisa jalan, tapi lebih lambat.${NC}"
    fi
}

# ─── Check & Install Homebrew ───────────────────────────────
check_brew() {
    echo -e "\n${BLUE}[1/6] Checking Homebrew...${NC}"
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}Homebrew belum ada. Installing...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add to PATH for Apple Silicon
        if [[ "$(uname -m)" == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        echo -e "${GREEN}Homebrew sudah terinstall ✅${NC}"
    fi
}

# ─── Check & Install Docker Desktop ────────────────────────
check_docker() {
    echo -e "\n${BLUE}[2/6] Checking Docker Desktop...${NC}"
    if ! command -v docker &> /dev/null; then
        echo -e "${YELLOW}Docker belum ada.${NC}"
        echo ""
        echo "Pilih cara install Docker Desktop:"
        echo "  1) Brew (otomatis, tapi besar ~1GB download)"
        echo "  2) Manual (buka browser, lo download sendiri)"
        echo ""
        read -p "Pilih [1/2]: " docker_choice
        
        if [[ "$docker_choice" == "1" ]]; then
            echo -e "${CYAN}Installing Docker Desktop via Homebrew...${NC}"
            brew install --cask docker
            echo -e "${YELLOW}[ACTION] Buka Docker Desktop dari Applications, tunggu sampai running.${NC}"
            echo -e "${YELLOW}         Tekan ENTER kalo Docker udah jalan (icon whale di menu bar)...${NC}"
            read -p ""
        else
            echo -e "${CYAN}Buka: https://www.docker.com/products/docker-desktop/${NC}"
            echo -e "${CYAN}Download 'Docker Desktop for Mac — Apple Silicon'${NC}"
            echo -e "${YELLOW}Install, buka, tunggu running. Tekan ENTER kalo udah...${NC}"
            read -p ""
        fi
    fi
    
    # Verify Docker is running
    if docker info &> /dev/null 2>&1; then
        echo -e "${GREEN}Docker Desktop running ✅${NC}"
    else
        echo -e "${RED}[ERROR] Docker belum running. Buka Docker Desktop dari Applications dulu.${NC}"
        echo -e "${YELLOW}Tekan ENTER kalo udah jalan...${NC}"
        read -p ""
        if ! docker info &> /dev/null 2>&1; then
            echo -e "${RED}Docker masih belum jalan. Start Docker Desktop dulu ya.${NC}"
            exit 1
        fi
    fi
}

# ─── Check & Install Cloudflared ────────────────────────────
check_cloudflared() {
    echo -e "\n${BLUE}[3/6] Checking Cloudflare Tunnel (cloudflared)...${NC}"
    if ! command -v cloudflared &> /dev/null; then
        echo -e "${CYAN}Installing cloudflared via Homebrew...${NC}"
        brew install cloudflared
    fi
    echo -e "${GREEN}cloudflared $(cloudflared --version 2>/dev/null | head -1) ✅${NC}"
}

# ─── Check .env ─────────────────────────────────────────────
check_env() {
    echo -e "\n${BLUE}[4/6] Checking .env configuration...${NC}"
    if [[ ! -f ".env" ]]; then
        echo -e "${YELLOW}.env file belum ada. Bikin dari template...${NC}"
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
        echo -e "${CYAN}Buka .env: ${NC}nano .env ${CYAN}atau${NC} open .env"
        echo ""
        echo "Panduan lengkap isi token: lihat folder docs/"
        echo "  - docs/02-setup-telegram.md  (token bot)"
        echo "  - docs/03-setup-cloudflare.md (tunnel token)"
        echo "  - docs/04-setup-llm.md       (API key LLM)"
        echo ""
        read -p "Tekan ENTER kalo .env udah lo isi..."
    fi
    
    # Validate critical vars
    source .env 2>/dev/null || true
    
    MISSING=0
    if [[ -z "$TELEGRAM_BOT_TOKEN" || "$TELEGRAM_BOT_TOKEN" == "your_telegram_bot_token_here" ]]; then
        echo -e "${RED}[MISSING] TELEGRAM_BOT_TOKEN belum diisi!${NC}"
        MISSING=1
    fi
    if [[ -z "$TELEGRAM_ALLOWED_USERS" || "$TELEGRAM_ALLOWED_USERS" == "your_telegram_user_id" ]]; then
        echo -e "${RED}[MISSING] TELEGRAM_ALLOWED_USERS belum diisi!${NC}"
        MISSING=1
    fi
    if [[ -z "$OPENROUTER_API_KEY" || "$OPENROUTER_API_KEY" == sk-or-v1-* ]] && \
       [[ -z "$GOOGLE_API_KEY" || "$GOOGLE_API_KEY" == AIza* ]] && \
       [[ -z "$ANTHROPIC_API_KEY" || "$ANTHROPIC_API_KEY" == sk-ant-* ]]; then
        # At least one must be set properly
        if [[ "$OPENROUTER_API_KEY" == "sk-or-v1-xxxxxxxxxxxxxxxxxxxx" ]] && \
           [[ "$GOOGLE_API_KEY" == "AIzaxxxxxxxxxxxxxxxxxxxxxxx" ]]; then
            echo -e "${RED}[MISSING] Minimal 1 API key LLM harus diisi! (OPENROUTER/GOOGLE/ANTHROPIC)${NC}"
            MISSING=1
        fi
    fi
    
    if [[ $MISSING -eq 1 ]]; then
        echo -e "\n${YELLOW}Isi dulu yang missing di .env, terus jalanin ulang ./install.sh${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}.env configuration OK ✅${NC}"
}

# ─── Create workspace directory ─────────────────────────────
setup_workspace() {
    echo -e "\n${BLUE}[5/6] Setting up workspace...${NC}"
    mkdir -p workspace
    echo -e "${GREEN}Workspace directory created ✅${NC}"
}

# ─── Start Services ─────────────────────────────────────────
start_services() {
    echo -e "\n${BLUE}[6/6] Starting Hermes Agent...${NC}"
    
    echo -e "${CYAN}Pulling Docker images (pertama kali agak lama ~2-5 menit)...${NC}"
    docker compose pull
    
    echo -e "${CYAN}Starting containers...${NC}"
    docker compose up -d
    
    # Wait for health check
    echo -e "${CYAN}Waiting for Hermes to be ready...${NC}"
    TRIES=0
    MAX_TRIES=30
    while [[ $TRIES -lt $MAX_TRIES ]]; do
        if docker compose exec -T hermes curl -sf http://localhost:8642/health > /dev/null 2>&1; then
            break
        fi
        TRIES=$((TRIES + 1))
        sleep 2
        echo -ne "\r  Waiting... ${TRIES}/${MAX_TRIES}"
    done
    echo ""
    
    if [[ $TRIES -ge $MAX_TRIES ]]; then
        echo -e "${YELLOW}[WARN] Hermes belum healthy setelah 60s. Cek logs: ./scripts/logs.sh${NC}"
    else
        echo -e "${GREEN}Hermes Agent is running! ✅${NC}"
    fi
}

# ─── Final Summary ──────────────────────────────────────────
summary() {
    source .env 2>/dev/null || true
    echo -e "\n${GREEN}"
    echo "╔══════════════════════════════════════════════════╗"
    echo "║         🎉 BUNSKII IS READY!                    ║"
    echo "╠══════════════════════════════════════════════════╣"
    echo "║                                                  ║"
    echo "║  Telegram: Buka bot lo di Telegram, kirim pesan ║"
    echo "║  Dashboard: https://${DOMAIN:-localhost}         ║"
    echo "║                                                  ║"
    echo "╠══════════════════════════════════════════════════╣"
    echo "║  Commands:                                       ║"
    echo "║  ./scripts/start.sh   - Start semua             ║"
    echo "║  ./scripts/stop.sh    - Stop semua              ║"
    echo "║  ./scripts/logs.sh    - Liat logs               ║"
    echo "║  ./scripts/update.sh  - Update Hermes           ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo "Selamat! Sekarang buka Telegram dan chat ke bot lo. 🚀"
}

# ─── Main ───────────────────────────────────────────────────
main() {
    check_os
    check_brew
    check_docker
    check_cloudflared
    check_env
    setup_workspace
    start_services
    summary
}

main "$@"
