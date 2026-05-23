# 02 — Setup Telegram Bot

## Step 1: Bikin Bot Baru

1. Buka Telegram
2. Search: **@BotFather** (verified, ada centang biru)
3. Chat dia, kirim: `/newbot`
4. Dia bakal tanya nama bot → ketik: `Bunskii Agent` (atau terserah lo)
5. Dia tanya username bot → ketik: `bunskii_agent_bot` (harus unik, harus end dengan `bot`)
6. BotFather kasih **token** kayak gini:
   ```
   6123456789:AAHdqTcvCH1vGWJxfSeofSAs0K5PALDsaw
   ```
7. **SIMPAN TOKEN INI!** Copy paste ke `.env` file:
   ```
   TELEGRAM_BOT_TOKEN=6123456789:AAHdqTcvCH1vGWJxfSeofSAs0K5PALDsaw
   ```

## Step 2: Dapetin Telegram User ID Lo

Ini supaya **cuma lo** yang bisa perintah bot (orang lain diabaikan).

1. Buka Telegram
2. Search: **@userinfobot**
3. Chat dia, kirim `/start`
4. Dia bakal reply dengan info lo, cari **Id**: `123456789`
5. Copy angka itu ke `.env`:
   ```
   TELEGRAM_ALLOWED_USERS=123456789
   ```

**Buat multiple users** (kalo mau ada yang lain juga bisa pake):
```
TELEGRAM_ALLOWED_USERS=123456789,987654321
```

## Step 3: Konfigurasi Bot (Opsional)

Masih di BotFather, lo bisa set:

```
/setdescription → "AI Agent pribadi gua. Bisa coding, browsing, nulis."
/setabouttext → "Powered by Hermes Agent + Claude/Gemini"
/setuserpic → upload gambar avatar bot
```

## Verifikasi

Token lo valid kalo bisa ditest lewat browser:
```
https://api.telegram.org/bot<TOKEN_LO>/getMe
```

Harusnya return JSON dengan info bot lo.

## Security Notes

- ⚠️ **JANGAN SHARE token bot ke siapapun**
- ⚠️ Kalo token bocor → revoke di BotFather: `/revoke`
- ✅ `TELEGRAM_ALLOWED_USERS` bikin cuma user ID tertentu yang direspon

## Next: [03 — Setup Cloudflare Tunnel](03-setup-cloudflare.md)
