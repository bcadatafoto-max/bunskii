# 03 — Setup Cloudflare Tunnel

## Kenapa Cloudflare Tunnel?

Laptop lo di rumah — gak punya IP publik (di-NAT router). Cloudflare Tunnel bikin "jembatan" dari internet ke laptop lo tanpa buka port, tanpa IP publik, gratis, auto HTTPS.

```
[Internet] → [Cloudflare] → [Tunnel terenkripsi] → [Laptop lo]
```

## Prerequisites

- Domain lo udah ada: **bunskii.biz.id** ✅
- Registrar: **IDwebhost** ✅
- Domain **harus pakai Cloudflare DNS** (nameserver Cloudflare)

## Step 1: Pindahin Domain ke Cloudflare DNS

Kalo domain lo belum di Cloudflare:

1. Buka https://dash.cloudflare.com → **Add a site**
2. Masukkin domain lo → pilih **Free plan**
3. Cloudflare kasih 2 nameserver, contoh:
   ```
   anna.ns.cloudflare.com
   bob.ns.cloudflare.com
   ```
4. Login ke **IDwebhost** (https://member.idwebhost.com)
5. Masuk ke **Domain Manager** → pilih `bunskii.biz.id` → **Nameservers**
6. Ganti nameserver ke yang Cloudflare kasih
6. Tunggu propagasi (5 menit - 48 jam, biasanya <1 jam)
7. Balik ke Cloudflare → klik **Check nameservers** → tunggu sampe ✅ Active

## Step 2: Bikin Tunnel

1. Buka https://one.dash.cloudflare.com (Cloudflare Zero Trust)
2. Sidebar kiri → **Networks** → **Tunnels**
3. Klik **Create a tunnel**
4. Pilih **Cloudflared** (bukan WARP)
5. Kasih nama: `bunskii`
6. Di halaman "Install connector", **jangan install** — kita jalan via Docker
7. **COPY TOKEN** yang dikasih (panjang banget, mulai dari `eyJ...`)
8. Paste ke `.env`:
   ```
   CLOUDFLARE_TUNNEL_TOKEN=eyJhIjoixxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```

## Step 3: Set Public Hostname

Masih di halaman tunnel yang sama:

1. Tab **Public Hostnames** → **Add a public hostname**
2. Isi:
   - **Subdomain**: `hermes` (atau kosongkan kalo mau root domain)
   - **Domain**: pilih domain lo
   - **Service Type**: HTTP
   - **URL**: `caddy:80`
3. **Save**

Sekarang `hermes.domainlo.com` → route ke Caddy → Hermes Agent.

## Step 4: Update .env

```env
DOMAIN=hermes.domainlo.com
CLOUDFLARE_TUNNEL_TOKEN=eyJhIjoixxxxxxxx...
```

## Verifikasi

Setelah `./scripts/start.sh`:

```bash
# Test dari Terminal
curl https://hermes.domainlo.com/health
# Expected: OK atau {"status":"ok"}

# Atau test via script
./scripts/tunnel.sh test
```

## Troubleshooting

| Problem | Solusi |
|---|---|
| "Bad gateway" / 502 | Hermes belum ready. Tunggu 30s, cek `./scripts/logs.sh hermes` |
| "Tunnel not found" | Token salah. Copy ulang dari Cloudflare dashboard |
| Domain gak resolve | Nameserver belum propagate. Tunggu / cek di https://dnschecker.org |
| Certificate error | Cloudflare handle cert otomatis. Kalo error, tunggu 5 menit |
| Cloudflared crash loop | Cek `./scripts/logs.sh cloudflared` — biasanya token expired |

## Alternative: Tanpa Domain (Development Only)

Kalo lo belum mau setup domain / cuma mau test:

```bash
# Jalanin quick tunnel (otomatis dapet URL random dari Cloudflare)
cloudflared tunnel --url http://localhost:8642
```

Ini kasih lo URL kayak `https://random-word-random.trycloudflare.com` — gak butuh domain, tapi berubah tiap restart.

## Next: [04 — Setup LLM API](04-setup-llm.md)
