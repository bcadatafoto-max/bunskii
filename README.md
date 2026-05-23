# 🤖 Bunskii — Hermes Agent Self-Hosted (MacBook + Telegram)

Setup otomatis **Hermes Agent** dari [Nous Research](https://github.com/NousResearch/hermes-agent) di MacBook M1 Pro, diakses via **Telegram Bot** dari mana aja, dengan **Cloudflare Tunnel** sebagai jembatan HTTPS gratis.

## 📋 Apa yang lo dapet

- ✅ AI Agent yang bisa coding, browsing, voice mode, nulis file, run command
- ✅ Akses dari **Telegram** (HP/laptop/dimana aja)
- ✅ HTTPS otomatis via **Cloudflare Tunnel** (gratis, gak perlu VPS)
- ✅ Multi-provider LLM (Claude, Gemini, DeepSeek, Hermes 3, dll)
- ✅ Self-improving — agent bisa nulis skill baru sendiri
- ✅ Persistent state — inget conversation & skill meskipun restart

## 🖥️ Requirements

| Komponen | Minimum | Lo punya |
|---|---|---|
| MacBook/Mac | M1 8GB | ✅ M1 Pro 16GB |
| Docker Desktop | v4.0+ | Install via script |
| Internet | stabil | ✅ |
| Domain | 1 domain | ✅ |
| Cloudflare account | gratis | Daftar gratis |
| Telegram account | aktif | ✅ |
| API Key LLM | 1+ provider | OpenRouter / Gemini |

## 🚀 Quick Start (30 menit)

```bash
# 1. Clone repo ini
git clone https://github.com/bcadatafoto-max/bunskii.git
cd bunskii

# 2. Copy config template
cp .env.example .env

# 3. Isi config (buka .env, isi semua token)
nano .env
# atau: open .env (buka di TextEdit)

# 4. Jalanin install script
chmod +x install.sh
./install.sh

# 5. Start Hermes Agent
./scripts/start.sh
```

Setelah itu, buka Telegram → chat ke bot lo → **langsung jalan!**

## 📁 Struktur Project

```
bunskii/
├── README.md                 # File ini
├── install.sh                # One-shot installer (macOS optimized)
├── docker-compose.yml        # Hermes + Caddy containers
├── Caddyfile                 # Reverse proxy + auto HTTPS
├── .env.example              # Template config (copy ke .env)
├── scripts/
│   ├── start.sh              # Start semua service
│   ├── stop.sh               # Stop semua service
│   ├── logs.sh               # Liat log Hermes
│   ├── update.sh             # Update Hermes ke versi terbaru
│   └── tunnel.sh             # Start/manage Cloudflare Tunnel
└── docs/
    ├── 01-setup-docker.md    # Install Docker Desktop
    ├── 02-setup-telegram.md  # Bikin bot Telegram
    ├── 03-setup-cloudflare.md # Setup Cloudflare Tunnel
    ├── 04-setup-llm.md       # Dapet API key LLM
    └── 05-troubleshooting.md # Solusi masalah umum
```

## 💰 Biaya Operasional

| Item | Biaya |
|---|---|
| VPS/Server | **Rp 0** (jalan di MacBook lo) |
| Cloudflare Tunnel | **Rp 0** (gratis) |
| Telegram Bot | **Rp 0** (gratis) |
| Domain | Udah punya |
| LLM API (Gemini Flash) | **Rp 0** (1500 req/hari gratis) |
| LLM API (Claude/DeepSeek) | ~Rp 50-150rb/bulan (opsional, buat quality lebih bagus) |
| **TOTAL MINIMUM** | **Rp 0/bulan** |

## 🔗 Links Penting

- [Hermes Agent Docs](https://hermes-agent.nousresearch.com/docs/)
- [Hermes Agent GitHub](https://github.com/NousResearch/hermes-agent)
- [OpenRouter (multi-model API)](https://openrouter.ai)
- [Google AI Studio (Gemini gratis)](https://aistudio.google.com)
- [Cloudflare Tunnel Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)

## ⚠️ Catatan Penting

- **Laptop harus nyala** pas lo mau pake bot dari Telegram
- Kalo internet rumah mati → bot gak bisa diakses
- Jangan share `.env` file ke siapapun (berisi API keys & tokens)
- Kalo nanti mau 24/7, tinggal pindahin ke VPS (semua config udah portable)

## 📖 Step-by-Step Guide (Detail)

Baca docs di folder `docs/` untuk panduan lengkap per step:
1. [Setup Docker](docs/01-setup-docker.md)
2. [Setup Telegram Bot](docs/02-setup-telegram.md)
3. [Setup Cloudflare Tunnel](docs/03-setup-cloudflare.md)
4. [Setup LLM API](docs/04-setup-llm.md)
5. [Troubleshooting](docs/05-troubleshooting.md)

---

Made with ❤️ for running your own AI agent from home.
