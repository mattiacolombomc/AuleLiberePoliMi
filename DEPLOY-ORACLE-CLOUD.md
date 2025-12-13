# 🚀 Deploy su Oracle Cloud Always Free (VERAMENTE GRATIS!)

Oracle Cloud offre **2 VM gratuite per sempre** - perfetto per bot Telegram sempre attivi!

## ✅ Vantaggi

- **100% Gratis per sempre** (non scade dopo 30 giorni!)
- **Sempre attivo** (no auto-sleep)
- **1GB RAM, 1 OCPU** (più che sufficiente per il bot)
- **200GB storage** incluso
- **10TB bandwidth/mese**
- **Protezione da costi**: le risorse Always Free non possono generare addebiti

---

## 📋 Setup Completo (20 minuti)

### **PARTE 1: Crea la VM su Oracle Cloud**

#### 1. Accedi alla Console Oracle Cloud

Vai su: https://cloud.oracle.com/

Accedi con il tuo account Oracle Cloud.

#### 2. Crea una VM Always Free

**Passaggi:**

1. **Menu hamburger** (☰) → **Compute** → **Instances**
2. Click **"Create Instance"**

**Configurazione VM:**

| Campo | Valore |
|-------|--------|
| **Name** | `aulelibere-bot` |
| **Compartment** | (root) o il tuo compartment |
| **Availability Domain** | Lascia default |
| **Image** | **Ubuntu 22.04 Minimal** (recommended) |
| **Shape** | **VM.Standard.E2.1.Micro** ⭐ (Always Free!) |
| | ↳ 1 OCPU, 1GB RAM |

⚠️ **IMPORTANTE**: Assicurati che lo shape sia **VM.Standard.E2.1.Micro** - è l'unico Always Free per AMD!

#### 3. Configura Networking

Nella sezione **"Networking"**:

- **VCN**: Crea nuovo VCN o usa quello esistente
- **Subnet**: Public subnet (default)
- ✅ **Assign a public IPv4 address**: ABILITA

#### 4. Aggiungi la tua chiave SSH

Nella sezione **"Add SSH keys"**:

**Opzione A - Hai già chiavi SSH:**
```bash
cat ~/.ssh/id_rsa.pub
```
Copia l'output e incollalo in "Paste public keys"

**Opzione B - Genera nuove chiavi:**
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/oracle_cloud_key
cat ~/.ssh/oracle_cloud_key.pub
```
Copia l'output e incollalo in "Paste public keys"

#### 5. Crea la VM

- Click **"Create"**
- Aspetta 2-3 minuti che la VM sia **"Running"** (pallino verde)
- ✅ **Copia l'IP pubblico** della VM (lo trovi nella pagina dell'istanza)

---

### **PARTE 2: Connettiti alla VM e installa il bot**

#### 1. Connettiti via SSH

```bash
# Se hai usato chiavi esistenti
ssh ubuntu@<IP_PUBBLICO_VM>

# Se hai generato nuove chiavi
ssh -i ~/.ssh/oracle_cloud_key ubuntu@<IP_PUBBLICO_VM>
```

Alla prima connessione, rispondi `yes` per accettare il fingerprint.

#### 2. Esegui lo script di setup automatico

Una volta dentro la VM:

```bash
# Diventa root
sudo su -

# Scarica lo script di setup
curl -fsSL https://raw.githubusercontent.com/mattiacolombomc/AuleLiberePoliMi/dev/oracle-setup.sh -o oracle-setup.sh

# Rendilo eseguibile
chmod +x oracle-setup.sh

# Esegui lo script
./oracle-setup.sh
```

Lo script ti chiederà:
- `TOKEN`: Il token del tuo bot Telegram (da BotFather)
- `DEVELOPER_CHAT_ID`: Il tuo Telegram user ID
- `CHANNEL_ID`: L'ID del canale per le notifiche
- `ADMIN_ID`: L'ID admin per monitoring

**Lo script installerà automaticamente:**
- ✅ Docker e Docker Compose
- ✅ Git
- ✅ Clone del repository
- ✅ Configurazione variabili ambiente
- ✅ Systemd service per auto-restart
- ✅ Avvio automatico al boot

#### 3. Verifica che il bot funzioni

```bash
# Vedi i logs del bot
sudo docker compose -f /opt/aulelibere/docker-compose.yml logs -f

# Dovresti vedere: "✅ Bot Aule Libere PoliMi è online!"
```

Prova a scrivere `/start` al bot su Telegram!

---

### **PARTE 3: Configura Portainer (Gestione Docker via Web)**

Portainer è già installato! Ti permette di gestire tutti i container Docker dal browser.

#### 1. Apri le porte su Oracle Cloud Security List

**DEVI fare questo passaggio** altrimenti non potrai accedere a Portainer!

1. **Console Oracle Cloud** → **Menu** (☰) → **Networking** → **Virtual Cloud Networks**
2. Click sul tuo VCN (quello della VM)
3. Sidebar sinistra → **Security Lists**
4. Click su **"Default Security List for..."**
5. Click **"Add Ingress Rules"**

**Aggiungi questa regola:**
- **Source CIDR**: `0.0.0.0/0` (tutto internet) o `<TUO_IP>/32` (solo il tuo IP - più sicuro!)
- **IP Protocol**: TCP
- **Destination Port Range**: `9000`
- **Description**: `Portainer`
- Click **"Add Ingress Rules"**

💡 Per trovare il tuo IP: https://whatismyipaddress.com/

#### 2. Accedi a Portainer

Apri il browser e vai a:
```
http://<IP_VM>:9000
```

**Esempio:**
```
http://158.101.123.45:9000
```

#### 3. Setup Portainer (prima volta)

1. **Crea password admin**
   - Username: `admin`
   - Password: scegli una password sicura!
   - Click **"Create user"**

2. **Seleziona environment**
   - Click **"Get Started"**
   - Seleziona **"Local"**
   - Click **"Connect"**

✅ **Fatto!** Ora puoi gestire Docker dal browser!

**Vedi `PORTAINER-GUIDE.md` per la guida completa su come usare Portainer.**

---

## 🔧 Gestione del Bot

### Comandi Utili

```bash
# Avvia il bot
sudo systemctl start aulelibere-bot

# Ferma il bot
sudo systemctl stop aulelibere-bot

# Riavvia il bot
sudo systemctl restart aulelibere-bot

# Vedi status
sudo systemctl status aulelibere-bot

# Vedi logs in tempo reale
sudo docker compose -f /opt/aulelibere/docker-compose.yml logs -f

# Vedi solo ultimi 100 log
sudo docker compose -f /opt/aulelibere/docker-compose.yml logs --tail=100
```

### Aggiornare il Bot

```bash
cd /opt/aulelibere
sudo git pull origin dev
sudo systemctl restart aulelibere-bot
```

---

## 🛡️ Protezione da Costi

### Budget Alerts (consigliato)

Per ricevere alert se superi il Free Tier:

1. **Console OCI** → **Billing & Cost Management** → **Budgets**
2. Click **"Create Budget"**
3. Imposta:
   - **Amount**: $1 (o $0)
   - **Alert threshold**: 80%, 100%
   - **Email**: la tua email

Se usi solo la VM Always Free → **non riceverai mai alert** (è gratis!)

### Cosa NON fare per restare gratis

❌ Non creare più di 2 VM AMD (sempre free)
❌ Non superare 4 OCPU ARM totali
❌ Non attivare servizi pay-as-you-go (Database, Container Registry oltre limite, ecc.)

✅ **Questo bot usa solo 1 VM AMD → 100% gratis sempre**

---

## 🔐 Sicurezza

### Cambia password di default (consigliato)

```bash
# Cambia password utente ubuntu
sudo passwd ubuntu
```

### Aggiorna il sistema regolarmente

```bash
sudo apt update && sudo apt upgrade -y
```

### Firewall

Oracle Cloud blocca tutte le porte in ingresso di default. Il bot usa **polling mode** (nessuna porta aperta), quindi sei già protetto.

---

## 📊 Monitoring

### Vedi uso risorse VM

```bash
# Uso CPU e RAM
htop

# Se htop non è installato
sudo apt install htop -y
htop

# Uso disco
df -h

# Uso Docker
sudo docker stats
```

### Dashboard Oracle Cloud

Vai su: **Console OCI** → **Compute** → **Instances** → `aulelibere-bot`

Puoi vedere:
- CPU usage
- Network traffic
- Metrics

---

## 🔄 Backup e Restore

### Backup configurazione

Il file `.env` contiene i secrets:

```bash
# Backup del .env
sudo cat /opt/aulelibere/.env

# Salvalo localmente (sul tuo PC)
```

### Backup dati bot

I dati del bot sono in:
- `/opt/aulelibere/data/aulelibere_pp` - Stato conversazioni
- `/opt/aulelibere/log/` - Logs

```bash
# Scarica backup sul tuo PC
scp ubuntu@<IP_VM>:/opt/aulelibere/data/aulelibere_pp ~/backup_bot.pkl
```

---

## ❓ Troubleshooting

### Bot non si avvia

```bash
# Vedi errori
sudo docker compose -f /opt/aulelibere/docker-compose.yml logs

# Controlla che le variabili ambiente siano settate
sudo cat /opt/aulelibere/.env
```

### VM non raggiungibile

- Controlla che la VM sia "Running" (verde) nella console Oracle
- Verifica l'IP pubblico nella console
- Controlla la tua chiave SSH

### Out of memory

Se la VM ha problemi di memoria (1GB):

```bash
# Crea swap file (2GB)
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Rendi permanente
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### Ricreare tutto da zero

```bash
sudo systemctl stop aulelibere-bot
sudo docker compose -f /opt/aulelibere/docker-compose.yml down -v
sudo rm -rf /opt/aulelibere
# Poi riesegui lo script di setup
```

---

## 💰 Costi

**ZERO** - Completamente gratis per sempre!

- ✅ VM Always Free: $0
- ✅ Storage: $0
- ✅ Bandwidth (entro 10TB/mese): $0
- ✅ Nessuna scadenza

**I crediti da $300 (30 giorni) sono EXTRA** - la VM Always Free resta gratis anche dopo!

---

## 📚 Info Utili

- **IP VM**: Salvalo in un posto sicuro
- **SSH Key**: Tieni una copia di backup
- **Region**: Oracle ti assegna la region più vicina (probabilmente Frankfurt o Zurigo per l'Italia)
- **Uptime**: La VM resta accesa 24/7 a meno che tu non la spenga manualmente

---

## 🆘 Supporto

- **Oracle Cloud Docs**: https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier.htm
- **Telegram Bot Issues**: https://github.com/mattiacolombomc/AuleLiberePoliMi/issues

---

**Fatto! Il bot è online e gratis per sempre! 🎉**
