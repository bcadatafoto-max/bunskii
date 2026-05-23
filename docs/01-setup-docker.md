# 01 — Setup Docker Desktop (macOS)

## Apa itu Docker?

Docker itu "kotak virtual" yang jalanin aplikasi secara terisolasi. Hermes Agent jalan di dalam Docker container biar gak ganggu macOS lo.

## Cara Install

### Opsi A: Via Homebrew (rekomen)

```bash
brew install --cask docker
```

### Opsi B: Manual Download

1. Buka: https://www.docker.com/products/docker-desktop/
2. Klik **"Download for Mac — Apple Silicon"**
3. Buka file `.dmg` → drag Docker ke Applications
4. Buka Docker dari Applications

## Setelah Install

1. Buka **Docker Desktop** dari Launchpad / Applications
2. Tunggu sampe icon 🐳 (whale) muncul di **menu bar** atas
3. Kalo minta permission → **Allow**
4. First time setup mungkin minta **restart**

## Verifikasi

Buka Terminal, ketik:

```bash
docker --version
# Output: Docker version 27.x.x, build xxxxxx

docker compose version
# Output: Docker Compose version v2.x.x
```

Kalo dua-duanya muncul versi → ✅ **done!**

## Settings Rekomendasi (Docker Desktop → Settings)

- **Resources → Memory**: Set ke **8 GB** (lo punya 16GB, kasih setengah ke Docker)
- **Resources → CPUs**: Set ke **4-6 cores**
- **Resources → Disk**: Biarin default (64GB cukup)
- **General → Start Docker Desktop when you log in**: **ON** (biar auto-start)

## Troubleshooting

| Problem | Solusi |
|---|---|
| "Cannot connect to Docker daemon" | Buka Docker Desktop dulu, tunggu sampe icon whale muncul |
| "docker: command not found" | Restart Terminal setelah install |
| Docker Desktop lambat start | Normal di first time, tunggu 1-2 menit |
| "Virtualization not supported" | Gak mungkin di M1 — coba restart Mac |

## Next: [02 — Setup Telegram Bot](02-setup-telegram.md)
