# 🚀 Deploy su Fly.io (Always-On Gratuito)

Fly.io offre 3 VM gratuite sempre attive - perfetto per bot Telegram!

## Quick Start (2 minuti)

### 1. Installa Fly.io CLI

**Mac:**
```bash
brew install flyctl
```

**Altri sistemi:**
```bash
curl -L https://fly.io/install.sh | sh
```

### 2. Login

```bash
flyctl auth login
```

Si aprirà il browser per login. Ti verrà chiesta la carta di credito per verifica (non addebita nulla sul piano free).

### 3. Deploy Automatico

```bash
./deploy-flyio.sh
```

Fatto! 🎉 Il bot è online e **sempre attivo**.

---

## Deploy Manuale (Step by Step)

Se preferisci farlo manualmente:

```bash
# 1. Crea l'app
flyctl apps create aulelibere-polimi

# 2. Configura secrets
flyctl secrets set \
    TOKEN="your_bot_token" \
    ADMIN_ID="your_admin_id" \
    DEVELOPER_CHAT_ID="your_developer_chat_id" \
    CHANNEL_ID="your_channel_id" \
    --app aulelibere-polimi

# 3. Deploy
flyctl deploy --app aulelibere-polimi
```

---

## Comandi Utili

```bash
# Vedi logs in tempo reale
flyctl logs --app aulelibere-polimi

# Status app
flyctl status --app aulelibere-polimi

# Riavvia bot
flyctl apps restart aulelibere-polimi

# Dashboard web
flyctl dashboard aulelibere-polimi

# SSH nel container
flyctl ssh console --app aulelibere-polimi

# Lista secrets
flyctl secrets list --app aulelibere-polimi

# Cambia secrets
flyctl secrets set TOKEN="new_token" --app aulelibere-polimi
```

---

## Configurazione

I file importanti sono:

- **`fly.toml`** - Configurazione app (region, risorse, always-on)
- **`Dockerfile`** - Immagine container
- **`.dockerignore`** - File esclusi dal build

### Always-On Configuration

Nel `fly.toml`:
```toml
auto_stop_machines = false  # Non spegnere mai
auto_start_machines = true
min_machines_running = 1    # Almeno 1 VM sempre attiva
```

---

## Costi

**GRATIS** con il free tier:
- ✅ 3 VM shared-cpu-1x (256MB RAM)
- ✅ 3GB persistent volume storage
- ✅ 160GB bandwidth/mese
- ✅ Sempre attivo (no auto-sleep)

Più che sufficiente per un bot Telegram!

---

## Troubleshooting

### App non risponde
```bash
flyctl logs --app aulelibere-polimi
```

### Webhook non funziona
Verifica che l'env var `FLY_APP_NAME` sia settata (automatica):
```bash
flyctl ssh console --app aulelibere-polimi
echo $FLY_APP_NAME
```

### Riavvio forzato
```bash
flyctl apps restart aulelibere-polimi
```

---

## Migrazione da Railway

Se hai già il bot su Railway:

1. Il codice è già compatibile (webhook detection automatica)
2. Fai deploy su Fly.io con lo script
3. Verifica che funzioni su Fly.io
4. Spegni Railway

I due possono coesistere brevemente durante la migrazione.

---

## Info Utili

- **Region**: `ams` (Amsterdam) - closest to Italy
- **URL bot**: `https://aulelibere-polimi.fly.dev`
- **Webhook**: `https://aulelibere-polimi.fly.dev/{TOKEN}`
- **Health check**: `https://aulelibere-polimi.fly.dev/`

---

Per supporto: https://fly.io/docs
