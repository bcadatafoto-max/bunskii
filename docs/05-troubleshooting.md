# 05 — Troubleshooting

## Masalah Umum & Solusi

### 🔴 Bot Telegram gak respon

**Cek 1:** Hermes running?
```bash
docker compose ps
# Semua harus "Up" / "running (healthy)"
```

**Cek 2:** Log ada error?
```bash
./scripts/logs.sh hermes
# Liat ada error message gak
```

**Cek 3:** Token bener?
- Pastiin `TELEGRAM_BOT_TOKEN` di `.env` gak ada spasi/newline di akhir
- Test: `curl https://api.telegram.org/bot<TOKEN>/getMe`

**Cek 4:** User ID lo termasuk allowed?
- Pastiin `TELEGRAM_ALLOWED_USERS` isinya angka ID lo (bukan username)

---

### 🔴 "Model not found" / "Unauthorized" error

- API key expired atau salah → generate ulang
- OpenRouter credit habis → top up
- Model name typo → cek di https://openrouter.ai/models

---

### 🔴 Docker containers restart terus

```bash
# Liat kenapa crash
docker compose logs --tail=50 hermes

# Common: port conflict
lsof -i :8642
# Kalo ada yang pake port itu, matiin dulu atau ganti HERMES_PORT di .env
```

---

### 🔴 Cloudflare Tunnel gak connect

```bash
# Cek status tunnel
./scripts/tunnel.sh status

# Cek token
./scripts/logs.sh cloudflared
# Kalo "failed to connect" → token expired, bikin ulang di Cloudflare dashboard
```

---

### 🔴 "Out of memory" / Container di-kill

MacBook M1 Pro 16GB harusnya aman, tapi kalo pake banyak app lain:

```bash
# Cek memory usage
docker stats

# Kalo hermes pake >8GB, restart:
docker compose restart hermes
```

Di Docker Desktop → Settings → Resources → turunin memory limit kalo perlu.

---

### 🔴 Laptop sleep → bot mati

macOS sleep = network mati = tunnel disconnect.

**Solusi:**
```bash
# Prevent sleep saat lid open (run di Terminal, Ctrl+C buat cancel):
caffeinate -s

# Atau di System Settings:
# Battery → Options → "Prevent automatic sleeping when display is off" → ON
```

**Atau:** Schedule sleep/wake:
- System Settings → Energy → Schedule: Wake at 07:00, Sleep at 23:00

---

### 🔴 Internet rumah gak stabil → bot disconnect

Cloudflare Tunnel otomatis reconnect, tapi kalo internet drop lama:
- Bot bakal unresponsive selama internet mati
- Begitu internet balik → auto-reconnect dalam 10-30 detik
- Conversation history tetap aman (persistent volume)

---

### 🟡 Hermes lambat respon

1. **Model choice** — Gemini Flash paling cepet, Claude lebih lambat tapi quality tinggi
2. **Internet speed** — kalo WiFi lambat, response LLM API juga lambat
3. **Docker resources** — buka Docker Desktop → Settings → Resources → naikin CPU/RAM

---

### 🟡 Mau reset conversation / clear memory

```bash
# Restart hermes (clear active memory, tapi skills tetap ada)
docker compose restart hermes

# Full reset (HATI-HATI - hapus semua data & skills)
docker compose down
docker volume rm bunskii_hermes_data bunskii_hermes_skills
docker compose up -d
```

---

## Useful Commands

```bash
# Status semua container
docker compose ps

# Realtime stats (CPU, RAM usage)
docker stats

# Masuk ke dalam container Hermes (debugging)
docker compose exec hermes sh

# Liat semua Docker volumes
docker volume ls | grep bunskii

# Rebuild from scratch
docker compose down --volumes
docker compose up -d --force-recreate
```

## Butuh Bantuan?

- Hermes Agent Docs: https://hermes-agent.nousresearch.com/docs/
- Hermes Agent GitHub Issues: https://github.com/NousResearch/hermes-agent/issues
- Cloudflare Tunnel Docs: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/
- Docker Desktop Docs: https://docs.docker.com/desktop/
