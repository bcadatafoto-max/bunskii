#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# BUNSKII Installer — Hermes Agent for macOS (Apple Silicon)
# Pakai installer NATIVE resmi dari Nous Research
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
echo "║       MacBook M1 Pro Edition                 ║"
echo "╠══════════════════════════════════════════════╣"
echo "║  Native install + Cloudflare Tunnel + LLM   ║"
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
    echo -e "\n${BLUE}[1/4] Checking Homebrew...${NC}"
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

# ─── Check & Install cloudflared ───────────────────────────
check_cloudflared() {
    echo -e "\n${BLUE}[2/4] Checking Cloudflare Tunnel (cloudflared)...${NC}"
    if ! command -v cloudflared &> /dev/null; then
        echo -e "${CYAN}Installing cloudflared via Homebrew...${NC}"
        brew install cloudflared
    fi
    echo -e "${GREEN}cloudflared $(cloudflared --version 2>/dev/null | head -1) ✅${NC}"
}

# ─── Install Hermes Agent (native) ─────────────────────────
install_hermes() {
    echo -e "\n${BLUE}[3/4] Installing Hermes Agent (native)...${NC}"

    if command -v hermes &> /dev/null; then
        echo -e "${GREEN}Hermes already installed: $(hermes --version 2>/dev/null || echo 'unknown') ✅${NC}"
        return
    fi

    echo -e "${CYAN}Running official Hermes installer dari Nous Research...${NC}"
    echo -e "${CYAN}  (akan install Python 3.11, Node.js, dll kalo belum ada)${NC}"
    curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

    # Add to PATH
    export PATH="$HOME/.local/bin:$PATH"

    if command -v hermes &> /dev/null; then
        echo -e "${GREEN}Hermes Agent installed ✅${NC}"
    else
        echo -e "${YELLOW}[WARN] Hermes belum kebaca di PATH. Jalanin: source ~/.zshrc${NC}"
        echo -e "${YELLOW}       Atau buka Terminal baru, terus jalanin: hermes${NC}"
    fi
}

# ─── Setup Cloudflare Tunnel (background) ──────────────────
setup_tunnel() {
    echo -e "\n${BLUE}[4/4] Setting up Cloudflare Tunnel...${NC}"

    if [[ ! -f ".env" ]]; then
        echo -e "${YELLOW}.env belum ada, copy dari template...${NC}"
        cp .env.example .env
    fi

    source .env 2>/dev/null || true

    if [[ -z "$CLOUDFLARE_TUNNEL_TOKEN" ]] || [[ "$CLOUDFLARE_TUNNEL_TOKEN" == "eyJhxxxxxxxxxxxxxxxx" ]]; then
        echo -e "${YELLOW}[SKIP] CLOUDFLARE_TUNNEL_TOKEN belum diisi di .env${NC}"
        echo -e "${YELLOW}       Tunnel bisa di-setup nanti, lo bisa lanjut configure Hermes dulu${NC}"
        return
    fi

    # Run cloudflared as a background brew service
    echo -e "${CYAN}Starting cloudflared as background service...${NC}"

    # Save token to a config so service can restart automatically
    mkdir -p ~/Library/LaunchAgents
    cat > /tmp/run_tunnel.sh << EOF
#!/bin/bash
cloudflared tunnel --no-autoupdate run --token $CLOUDFLARE_TUNNEL_TOKEN
EOF
    chmod +x /tmp/run_tunnel.sh

    # Start tunnel in background
    nohup cloudflared tunnel --no-autoupdate run --token "$CLOUDFLARE_TUNNEL_TOKEN" > /tmp/cloudflared.log 2>&1 &
    echo $! > /tmp/cloudflared.pid

    sleep 2
    if kill -0 $(cat /tmp/cloudflared.pid) 2>/dev/null; then
        echo -e "${GREEN}Cloudflare Tunnel running (PID: $(cat /tmp/cloudflared.pid)) ✅${NC}"
        echo -e "${CYAN}  Logs: tail -f /tmp/cloudflared.log${NC}"
    else
        echo -e "${YELLOW}[WARN] Tunnel mungkin gagal start. Cek logs: cat /tmp/cloudflared.log${NC}"
    fi
}

# ─── Final Summary ──────────────────────────────────────────
summary() {
    source .env 2>/dev/null || true
    echo -e "\n${GREEN}"
    echo "╔══════════════════════════════════════════════════╗"
    echo "║         🎉 INSTALLATION COMPLETE!               ║"
    echo "╠══════════════════════════════════════════════════╣"
    echo "║                                                  ║"
    echo "║  Next Steps:                                    ║"
    echo "║                                                  ║"
    echo "║  1. Buka Terminal baru (atau: source ~/.zshrc)  ║"
    echo "║  2. Jalanin: hermes                             ║"
    echo "║     → ikutin wizard config (LLM, Telegram, dll) ║"
    echo "║  3. Hermes start otomatis di port 8642          ║"
    echo "║  4. Tunnel route → http://localhost:8642        ║"
    echo "║                                                  ║"
    echo "╠══════════════════════════════════════════════════╣"
    echo "║  Useful commands:                               ║"
    echo "║  hermes              - Start Hermes             ║"
    echo "║  hermes config       - Edit config              ║"
    echo "║  hermes model        - Switch LLM model         ║"
    echo "║  hermes --help       - All commands             ║"
    echo "║  tail -f /tmp/cloudflared.log - Tunnel logs     ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# ─── Main ───────────────────────────────────────────────────
main() {
    check_os
    check_brew
    check_cloudflared
    install_hermes
    setup_tunnel
    summary
}

main "$@"
