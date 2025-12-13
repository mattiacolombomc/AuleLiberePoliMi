# 🎛️ Guida Portainer - Gestisci Docker dal Browser

Portainer è installato automaticamente con il bot e ti permette di gestire tutti i container Docker tramite interfaccia web.

---

## 🚀 Accesso a Portainer

### Step 1: Apri le porte su Oracle Cloud Security List

**IMPORTANTE**: Oracle Cloud blocca tutte le porte di default. Devi aprirle manualmente.

#### 1. Vai alla Console Oracle Cloud

https://cloud.oracle.com/

#### 2. Naviga alla Security List

1. **Menu** (☰) → **Networking** → **Virtual Cloud Networks**
2. Click sul tuo VCN (quello della VM)
3. Nel menu a sinistra → **Security Lists**
4. Click su **"Default Security List for..."**

#### 3. Aggiungi Ingress Rules per Portainer

Click **"Add Ingress Rules"** e compila:

**Regola 1 - Portainer HTTP:**
- **Source Type**: CIDR
- **Source CIDR**: `0.0.0.0/0` (tutto internet) o `<TUO_IP>/32` (solo il tuo IP - più sicuro!)
- **IP Protocol**: TCP
- **Destination Port Range**: `9000`
- **Description**: `Portainer HTTP`
- Click **"Add Ingress Rules"**

**Regola 2 - Portainer HTTPS:**
- **Source CIDR**: `0.0.0.0/0` (o il tuo IP)
- **IP Protocol**: TCP
- **Destination Port Range**: `9443`
- **Description**: `Portainer HTTPS`
- Click **"Add Ingress Rules"**

⚠️ **Suggerimento sicurezza**: Usa il tuo IP invece di `0.0.0.0/0` se hai IP fisso!

Per trovare il tuo IP: https://whatismyipaddress.com/

---

### Step 2: Accedi a Portainer

Apri il browser e vai a:

```
http://<IP_VM>:9000
```

oppure (HTTPS):

```
https://<IP_VM>:9443
```

**Esempio:**
```
http://158.101.123.45:9000
```

---

### Step 3: Setup iniziale

**Alla prima apertura:**

1. **Crea admin user**
   - Username: `admin`
   - Password: **scegli una password sicura!** (min 12 caratteri)
   - Click **"Create user"**

2. **Seleziona environment**
   - Click **"Get Started"**
   - Seleziona **"Local"** (Docker locale sulla VM)
   - Click **"Connect"**

✅ **Fatto!** Sei dentro Portainer!

---

## 🎯 Come usare Portainer

### Dashboard principale

Vedrai:
- **Containers**: Tutti i container (bot, portainer, ecc.)
- **Images**: Immagini Docker scaricate
- **Volumes**: Volumi per dati persistenti
- **Networks**: Reti Docker

---

### 📦 Gestire i Container

#### Vedere tutti i container

1. Sidebar sinistra → **Containers**
2. Vedi lista completa con:
   - Nome
   - Stato (running/stopped)
   - CPU/RAM usage
   - Porte esposte

#### Vedere i logs di un container

1. Click sul container (es. `aulelibere-bot`)
2. Tab **"Logs"**
3. ✅ Logs in tempo reale!
4. Puoi:
   - Scaricare i logs
   - Cercare nel testo
   - Auto-refresh

#### Riavviare un container

1. Click sul container
2. In alto: **Actions** → **Restart**
3. Conferma

Oppure dalla lista:
- Checkbox sul container → **Restart** in alto

#### Fermare/Avviare container

1. Checkbox sul container
2. **Stop** / **Start** / **Kill** in alto

#### Aprire shell dentro un container

1. Click sul container
2. Tab **"Console"**
3. Click **"Connect"**
4. Hai una shell interattiva! 🎉

Utile per debug o vedere file dentro il container.

---

### 📊 Monitorare risorse

#### Stats container in tempo reale

1. Click sul container
2. Tab **"Stats"**
3. Vedi grafici:
   - CPU %
   - RAM usage
   - Network I/O
   - Disk I/O

#### Stats di tutti i container

1. Sidebar → **Containers**
2. Nella lista vedi colonne:
   - CPU
   - Memory
   - Network

---

### 🖼️ Gestire Immagini Docker

1. Sidebar → **Images**
2. Vedi tutte le immagini scaricate
3. Puoi:
   - Scaricare nuove immagini (Pull)
   - Cancellare immagini non usate
   - Vedere dimensioni

---

### 💾 Gestire Volumi

1. Sidebar → **Volumes**
2. Vedi tutti i volumi:
   - `portainer_data` (dati Portainer)
   - Volumi del bot
3. Puoi:
   - Vedere contenuto
   - Backup
   - Cancellare (attenzione!)

---

### 🚀 Deploy nuovi container

#### Da Docker Compose

1. Sidebar → **Stacks**
2. **"Add stack"**
3. Nome stack (es. `nuovo-bot`)
4. Incolla il tuo `docker-compose.yml`
5. **"Deploy the stack"**

#### Container singolo

1. Sidebar → **Containers**
2. **"Add container"**
3. Compila form:
   - Nome
   - Immagine (es. `nginx:alpine`)
   - Porte
   - Variabili ambiente
4. **"Deploy the container"**

---

## 🔧 Comandi utili da terminale

Anche con Portainer, a volte è utile SSH:

```bash
# SSH nella VM
ssh ubuntu@<IP_VM>

# Vedi containers
sudo docker ps

# Vedi logs bot
sudo docker logs -f aulelibere-bot

# Vedi logs Portainer
sudo docker logs -f portainer

# Riavvia tutto
sudo systemctl restart aulelibere-bot

# Ferma tutto
sudo systemctl stop aulelibere-bot
```

---

## 📱 Portainer da mobile

Portainer ha anche **app mobile**!

- **iOS**: https://apps.apple.com/app/portainer/id1560592767
- **Android**: https://play.google.com/store/apps/details?id=io.portainer.android

Gestisci i container dal telefono! 📱

---

## 🔐 Sicurezza

### Cambia password admin

1. Click icona user (in alto a destra)
2. **"My account"**
3. **"Change password"**

### Limita accesso solo dal tuo IP

Nella Security List di Oracle Cloud, cambia:
- Da: `0.0.0.0/0`
- A: `<TUO_IP>/32`

Così solo tu puoi accedere a Portainer!

### Abilita HTTPS (opzionale)

Di default Portainer usa HTTP (porta 9000).

Per HTTPS sicuro:
1. Usa porta 9443 invece di 9000
2. Portainer genera certificato self-signed
3. Browser ti avviserà (certificato non fidato), ignora e procedi

Oppure configura certificato Let's Encrypt (avanzato).

---

## 🆘 Troubleshooting

### Portainer non accessibile

**Verifica firewall VM:**
```bash
sudo iptables -L INPUT -n --line-numbers | grep 9000
```
Dovresti vedere la regola.

**Verifica container running:**
```bash
sudo docker ps | grep portainer
```

**Riavvia Portainer:**
```bash
sudo docker restart portainer
```

### Ho dimenticato la password

Reset password admin:

```bash
# Ferma Portainer
sudo docker stop portainer

# Rimuovi container e volume
sudo docker rm portainer
sudo docker volume rm portainer_data

# Riavvia tutto (ricreerà Portainer)
sudo systemctl restart aulelibere-bot
```

⚠️ Perderai configurazioni personalizzate in Portainer!

---

## 💡 Tips & Tricks

### Auto-cleanup immagini non usate

1. Sidebar → **Settings**
2. Abilita **"Automatic removal of unused images"**
3. Risparmia spazio disco!

### Notifiche webhook

Portainer può mandare webhook quando succede qualcosa:
1. Settings → **Notifications**
2. Aggiungi webhook (es. Discord/Slack/Telegram)

### Templates custom

1. Sidebar → **App Templates**
2. Aggiungi template per container che usi spesso
3. Deploy con 1 click!

---

## 🔄 Auto-Deploy con GitHub Webhook

Configura il deploy automatico per aggiornare i tuoi stack ad ogni push su GitHub!

### Prerequisito: Stack da Repository Git

Il webhook funziona solo con stack creati tramite **Git Repository** (non Web Editor).

### Step 1: Crea Stack da Repository

1. Sidebar → **Stacks** → **+ Add stack**
2. **Name**: nome dello stack (es. `aulelibere`)
3. **Build method**: seleziona **`Repository`**
4. **Repository URL**: `https://github.com/tuouser/tuarepo`
5. **Repository reference**: `refs/heads/dev` (o `main`)
6. **Compose path**: `docker-compose.yml`
7. **GitOps updates**: ✓ **Enable**
8. **Mechanism**: seleziona **`Webhook`**
9. Aggiungi **Environment variables** se necessarie
10. **Deploy the stack**

### Step 2: Copia Webhook URL

Dopo il deploy, nella pagina dello stack vedrai:

```
Webhook
http://<IP_VM>:9000/api/stacks/webhooks/abc123-token-secret
```

**Copia questo URL!** (contiene token segreto)

### Step 3: Configura GitHub Webhook

1. Vai su: **https://github.com/tuouser/tuarepo/settings/hooks**
2. Click **"Add webhook"**
3. **Payload URL**: incolla l'URL da Portainer
4. **Content type**: `application/json`
5. **Which events**: ☑️ `Just the push event`
6. **Active**: ✓ spunta
7. **Add webhook**

### Step 4: Test

```bash
git commit --allow-empty -m "Test webhook"
git push origin dev
```

Vai su Portainer → Stack → dovresti vedere l'aggiornamento automatico! 🎉

### Verifica Webhook su GitHub

Vai su: **Settings** → **Webhooks** → click sul webhook appena creato

Vedrai:
- ✅ **Segno verde** = webhook funzionante
- ❌ **X rossa** = c'è un problema (controlla Payload/Response)

---

## 📚 Risorse

- **Documentazione ufficiale**: https://docs.portainer.io/
- **Demo online**: https://demo.portainer.io/ (per provare)
- **Forum**: https://community.portainer.io/

---

**Buon divertimento con Portainer! 🎉**

Ora gestire Docker è facile come cliccare bottoni! 🖱️
