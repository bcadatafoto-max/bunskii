# 01 — Install Hermes Agent (Native, no Docker)

## Apa yang di-install?

Hermes Agent dari Nous Research di-install **native** di MacBook lo (bukan via Docker). Installer resminya udah handle semua dependency: Python 3.11, Node.js, Git.

## Cara Install

Cukup 1 command di Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

Tunggu ~3-5 menit. Installer bakal:
- Cek dependency yang ada
- Install yang belum ada (Python, Node, Git via uv)
- Clone Hermes ke `~/.hermes/hermes-agent`
- Bikin virtual env
- Symlink command `hermes` ke `~/.local/bin`

## Verifikasi

```bash
source ~/.zshrc
hermes --version
```

Harusnya muncul versi Hermes.

## Setelah install

Jalanin:

```bash
hermes
```

Pertama kali jalan, Hermes bakal kasih wizard config:
- Pilih LLM provider
- Masukin API key
- Pilih default model

Setelah itu lo udah bisa chat di Terminal.

## Lihat juga

- [Quickstart resmi](https://hermes-agent.nousresearch.com/docs/getting-started/quickstart)
- [Installation docs](https://hermes-agent.nousresearch.com/docs/getting-started/installation)
- Repo GitHub: https://github.com/NousResearch/hermes-agent

## Next: [02 — Setup Telegram Bot](02-setup-telegram.md)
