# 04 — Setup LLM API (Otak AI-nya)

Hermes Agent butuh "otak" — LLM (Large Language Model) yang jalan di cloud. Lo gak perlu run model di laptop, cukup panggil API mereka.

## Pilihan Provider (pilih minimal 1)

### 🆓 Opsi 1: Google Gemini (GRATIS)

**Gratis 1500 request/hari** — cukup buat pemakaian normal.

1. Buka https://aistudio.google.com/apikey
2. Login pake Google account
3. Klik **"Create API Key"**
4. Copy key → paste ke `.env`:
   ```
   GOOGLE_API_KEY=AIzaSyXXXXXXXXXXXXXXXXXXXXX
   DEFAULT_MODEL=google/gemini-2.5-flash
   ```

**Kelebihan:** Gratis, fast, bagus buat general task
**Kekurangan:** Coding quality di bawah Claude, rate limited

---

### ⭐ Opsi 2: OpenRouter (REKOMEN — Multi-Model)

1 API key, akses ke 100+ model (Claude, Gemini, DeepSeek, Hermes 3, dll).

1. Buka https://openrouter.ai
2. Sign up (bisa pake Google/GitHub)
3. Dashboard → **Keys** → **Create Key**
4. Copy key → paste ke `.env`:
   ```
   OPENROUTER_API_KEY=sk-or-v1-xxxxxxxxxxxxxxxxxxxx
   DEFAULT_MODEL=google/gemini-2.5-flash
   ```
5. **Top up credit**: klik **Credits** → minimal $5 (Rp ~80rb)
   - Payment: Kartu kredit / crypto
   - Bisa pake model gratis dulu tanpa top up!

**Model gratis di OpenRouter:**
- `google/gemini-2.5-flash` — gratis
- `nousresearch/hermes-3-llama-3.1-405b:free` — kadang gratis
- `meta-llama/llama-3.3-70b-instruct:free` — gratis

**Model bayar tapi bagus buat coding:**
- `anthropic/claude-sonnet-4-20250514` — $3/$15 per M token (TERBAIK buat coding)
- `deepseek/deepseek-chat` — $0.27/$1.10 per M token (TERMURAH yg bagus)
- `anthropic/claude-haiku-3.5` — $1/$5 per M token (balance speed + quality)

---

### 💵 Opsi 3: Anthropic Claude (Direct)

Kualitas coding TERBAIK. Langsung dari Anthropic (tanpa OpenRouter).

1. Buka https://console.anthropic.com
2. Sign up → verify
3. **API Keys** → **Create Key**
4. Paste ke `.env`:
   ```
   ANTHROPIC_API_KEY=sk-ant-api03-xxxxxxxxxxxx
   DEFAULT_MODEL=anthropic/claude-sonnet-4-20250514
   ```
5. Top up credit (minimum $5)

---

### 💵 Opsi 4: DeepSeek (Paling Murah)

Coding bagus, harga paling murah di market.

1. Buka https://platform.deepseek.com
2. Sign up → API Keys → Create
3. Paste ke `.env`:
   ```
   DEEPSEEK_API_KEY=sk-xxxxxxxxxxxxxxxx
   DEFAULT_MODEL=deepseek/deepseek-chat
   ```
4. Top up (bisa $2 aja, tahan lama karena murah)

## Rekomendasi Setup

### Budget Rp 0 (gratis total):
```env
GOOGLE_API_KEY=AIzaXXXXXXXXXXXX
DEFAULT_MODEL=google/gemini-2.5-flash
```

### Budget Rp 50-100rb/bulan (sweet spot):
```env
OPENROUTER_API_KEY=sk-or-v1-XXXXXXX
DEFAULT_MODEL=deepseek/deepseek-chat
# Switch ke Claude kalo butuh kualitas lebih:
# DEFAULT_MODEL=anthropic/claude-sonnet-4-20250514
```

### Best quality (gak peduli biaya):
```env
ANTHROPIC_API_KEY=sk-ant-XXXXXXX
DEFAULT_MODEL=anthropic/claude-sonnet-4-20250514
```

## Estimasi Biaya per Bulan

| Pemakaian | Gemini Flash | DeepSeek V3 | Claude Sonnet |
|---|---|---|---|
| Ringan (10 chat/hari) | Rp 0 | ~Rp 15rb | ~Rp 50rb |
| Medium (30 chat/hari) | Rp 0 | ~Rp 50rb | ~Rp 150rb |
| Heavy (100+ chat/hari) | Rp 0* | ~Rp 150rb | ~Rp 500rb+ |

*Gemini free tier = 1500 req/hari, harusnya cukup

## Ganti Model On-The-Fly

Nanti di Telegram, lo bisa ganti model tanpa restart:
```
/model deepseek/deepseek-chat
/model anthropic/claude-sonnet-4-20250514
/model google/gemini-2.5-flash
```

## Next: [05 — Troubleshooting](05-troubleshooting.md)
