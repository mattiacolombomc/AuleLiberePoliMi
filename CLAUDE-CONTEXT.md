# 🤖 Context per Claude Code - Oracle Cloud Infrastructure

**Usa questo file per inizializzare conversazioni con Claude Code quando lavori su questo progetto.**

---

## 📍 Infrastruttura Attuale

### VM Oracle Cloud #1 (Principale)

**Dettagli VM:**
- **IP Pubblico**: `80.225.91.200`
- **Nome**: `aulelibere-bot-v2`
- **OS**: Ubuntu 22.04 LTS
- **Resources**: 1GB RAM, 1 OCPU (VM.Standard.E2.1.Micro - Always Free)
- **Region**: EU Milan
- **SSH**: `ssh ubuntu@80.225.91.200`

**Stack Docker:**
- **Portainer** (standalone): `http://80.225.91.200:9000` (porte 9000, 9443)
  - Username: `admin`
  - Password: salvata in 1Password
  - Container: `portainer` (sempre attivo, auto-restart)

- **Stack aulelibere** (gestito da Portainer):
  - Container: `aulelibere-bot` (bot Telegram, porta 8080)
  - Auto-deploy: ✅ Webhook GitHub → Portainer configurato
  - Repository: https://github.com/mattiacolombomc/AuleLiberePoliMi
  - Branch: `dev`

**Porte Aperte (Oracle Cloud Security List):**
- 9000/tcp (Portainer HTTP)
- 9443/tcp (Portainer HTTPS)
- 8080/tcp (Bot webhook - opzionale)

**File Importanti sulla VM:**
- `/opt/aulelibere/` - Directory del bot
- `/opt/aulelibere/.env` - Variabili ambiente (secrets)
- `/opt/aulelibere/data/` - Dati persistenti bot
- `/opt/aulelibere/log/` - Logs

**Monitoring:**
- UptimeRobot configurato per monitorare Portainer

---

## 📦 Repository GitHub

**Repository**: https://github.com/mattiacolombomc/AuleLiberePoliMi

**Branch principale**: `dev`

**Branch attivo**: `dev` (o `feature/advanced-filters`)

**Auto-Deploy**: ✅ Configurato
- Webhook GitHub → Portainer
- Ad ogni `git push origin dev` → deploy automatico sulla VM

**File Chiave:**
- `Dockerfile` - Include gcc per regex package
- `docker-compose.yml` - Definisce SOLO il bot (Portainer è standalone)
- `oracle-setup.sh` - Script setup automatico VM
- `DEPLOY-ORACLE-CLOUD.md` - Guida deployment completa
- `PORTAINER-GUIDE.md` - Guida uso Portainer
- `CLAUDE-CONTEXT.md` - Questo file!

---

## ⚙️ Configurazione Git/Claude

**Settings Claude Code** (`~/.config/claude-code/settings.json`):
```json
{
  "includeClaudeSignature": false
}
```

**IMPORTANTE**:
- ❌ **NON includere mai Claude co-author nei commit!**
- ✅ Tutti i commit solo a nome mio (Mattia Colombo)

---

## 🚀 Workflow Manutenzione

**Settimanale:**
- Check UptimeRobot status
- Review logs Portainer (Stacks → aulelibere → Logs)

**Mensile:**
- SSH nella VM: `ssh ubuntu@80.225.91.200`
- Update sistema: `sudo apt update && sudo apt upgrade -y`
- Pull immagini Docker: `sudo docker compose pull` (se non auto-deploy)

**Trimestrale:**
- Backup file `.env`: `sudo cat /opt/aulelibere/.env` (salvare localmente)
- Backup dati bot: `scp ubuntu@80.225.91.200:/opt/aulelibere/data/aulelibere_pp ~/backup_bot.pkl`
- Review completo sicurezza e risorse

---

## 🔧 Come Aggiungere Nuovi Progetti alla VM

**La VM può hostare più bot/scrapers/API! Ecco come:**

### Opzione A: Nuovo Stack in Portainer (Consigliato)

1. **Prepara repository GitHub**:
   - Crea nuovo repo (es. `mio-scraper`)
   - Aggiungi `docker-compose.yml` al root
   - Push su GitHub

2. **Crea Stack in Portainer**:
   - Portainer → **Stacks** → **+ Add stack**
   - **Name**: `mio-scraper`
   - **Build method**: `Repository`
   - **Repository URL**: `https://github.com/mattiacolombomc/mio-scraper`
   - **Repository reference**: `refs/heads/main`
   - **Compose path**: `docker-compose.yml`
   - **GitOps updates**: ✓ Enable + Webhook
   - **Deploy**

3. **Configura Webhook** (opzionale):
   - Copia webhook URL da Portainer
   - GitHub repo → Settings → Webhooks → Add webhook

4. **Apri porte** (se necessario):
   - Oracle Cloud Console → Networking → Security Lists
   - Add Ingress Rules per le porte del nuovo progetto

### Opzione B: Aggiungere servizio allo stack esistente

Modifica `docker-compose.yml` nel repository:

```yaml
services:
  bot:
    # ... bot esistente

  nuovo-servizio:
    image: python:3.11-slim
    container_name: mio-scraper
    restart: unless-stopped
    environment:
      - API_KEY=${API_KEY}
    volumes:
      - ./scraper-data:/app/data
    networks:
      - bot-network
```

Push su GitHub → auto-deploy! 🚀

### Limiti da Considerare

**Risorse VM (1GB RAM, 1 OCPU):**
- ~3-5 bot/scrapers leggeri: ✅ OK
- Database pesanti (MySQL, Postgres): ⚠️ Attenzione (meglio su VM #2)
- Applicazioni CPU-intensive: ⚠️ Limitato

**Spazio Disco (200GB):**
- Ampio margine per logs, dati, immagini Docker

**Monitoraggio risorse:**
```bash
ssh ubuntu@80.225.91.200
htop  # CPU/RAM usage
df -h  # Disk usage
sudo docker stats  # Container stats
```

---

## 🖥️ Come Creare una Seconda VM (Clone Setup)

Oracle offre **2 VM Always Free**! Ecco come clonare il setup:

### Step 1: Crea VM #2 su Oracle Cloud

1. **Console OCI** → **Compute** → **Instances** → **Create Instance**
2. **Name**: `aulelibere-bot-v3` (o altro nome)
3. **Shape**: `VM.Standard.E2.1.Micro` ⭐ (Always Free!)
4. **Image**: Ubuntu 22.04 Minimal
5. **VCN**: Usa lo stesso VCN della VM #1 (o crea nuovo)
6. **Subnet**: Public subnet
7. **SSH keys**: Usa stessa chiave o generane una nuova
8. **Create**

### Step 2: Setup Identico

**Metodo rapido** - Usa script automatico:

```bash
# Connettiti a VM #2
ssh ubuntu@<IP_VM2>

# Diventa root
sudo su -

# Scarica e esegui setup script
curl -fsSL https://raw.githubusercontent.com/mattiacolombomc/AuleLiberePoliMi/dev/oracle-setup.sh -o oracle-setup.sh
chmod +x oracle-setup.sh
./oracle-setup.sh
```

### Step 3: Configura Portainer Standalone

```bash
# Ferma stack (se Portainer era incluso)
cd /opt/aulelibere
sudo docker compose down

# Avvia Portainer standalone
sudo docker run -d \
  --name portainer \
  --restart=unless-stopped \
  -p 9000:9000 -p 9443:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

### Step 4: Apri Porte su VM #2

Ripeti il processo di Security List per la nuova VM:
- Porta 9000 (Portainer)
- Porta 9443 (Portainer HTTPS)
- Altre porte necessarie

### Step 5: Crea Stack in Portainer VM #2

Segui procedura normale per creare stack da repository Git + webhook.

### Casi d'Uso VM #2

**Esempi di cosa mettere sulla seconda VM:**
- Database (MySQL, PostgreSQL, MongoDB)
- API backend separate
- Scraper/crawler pesanti
- Dev/staging environment (VM #1 = prod, VM #2 = staging)
- Progetti personali separati

---

## 🛠️ Comandi Utili Rapidi

```bash
# SSH nella VM
ssh ubuntu@80.225.91.200

# Vedi tutti i container
sudo docker ps

# Vedi logs bot
sudo docker logs -f aulelibere-bot

# Vedi logs Portainer
sudo docker logs -f portainer

# Riavvia Portainer
sudo docker restart portainer

# Vedi uso risorse
htop
sudo docker stats

# Update sistema
sudo apt update && sudo apt upgrade -y

# Backup .env
sudo cat /opt/aulelibere/.env > ~/env_backup.txt
```

---

## 📞 Info di Supporto

**Oracle Cloud Console**: https://cloud.oracle.com/

**Portainer VM #1**: http://80.225.91.200:9000

**Repository GitHub**: https://github.com/mattiacolombomc/AuleLiberePoliMi

**Documentazione**:
- `DEPLOY-ORACLE-CLOUD.md` - Setup completo VM
- `PORTAINER-GUIDE.md` - Guida Portainer
- `CLAUDE-CONTEXT.md` - Questo file

**Monitoring**:
- UptimeRobot: configurato per Portainer
- GitHub Webhooks: Settings → Webhooks

---

## 💡 Tips per Claude Code

Quando inizi una nuova conversazione con Claude Code e hai bisogno di lavorare su questo progetto:

**Copia e incolla questo prompt:**

```
Ho un bot Telegram deployato su Oracle Cloud Always Free.

**Setup attuale:**
- VM Oracle: 80.225.91.200 (Ubuntu 22.04, 1GB RAM)
- Portainer standalone: http://80.225.91.200:9000 (admin/password in 1Password)
- Stack bot: gestito da Portainer con auto-deploy via webhook GitHub
- Repository: https://github.com/mattiacolombomc/AuleLiberePoliMi (branch: dev)
- Auto-deploy: ✅ Ogni push su dev → auto-update sulla VM

**File importanti:**
- docker-compose.yml (solo bot, Portainer è standalone)
- DEPLOY-ORACLE-CLOUD.md (guida deployment)
- PORTAINER-GUIDE.md (guida Portainer)
- CLAUDE-CONTEXT.md (questo contesto completo)

**Git settings:**
- includeClaudeSignature: false (commit SOLO a nome mio!)

Leggi CLAUDE-CONTEXT.md per dettagli completi.

**Cosa voglio fare:**
[Descrivi qui cosa vuoi fare: aggiungere bot, creare seconda VM, modificare bot esistente, ecc.]
```

---

**Ultimo aggiornamento**: 13 Dicembre 2025
**Status**: ✅ Bot online, Portainer configurato, Auto-deploy attivo
