#!/bin/bash

# Script di setup automatico per Oracle Cloud VM (Ubuntu)
# Esegui questo script sulla VM Ubuntu dopo averla creata

set -e  # Exit on error

echo "🚀 Setup Bot Telegram su Oracle Cloud Always Free"
echo "=================================================="
echo ""

# Colori
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verifica di essere root o sudo
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ Esegui come root o con sudo${NC}"
    exit 1
fi

# 1. Update sistema
echo -e "${BLUE}📦 Step 1/7: Aggiornamento sistema...${NC}"
apt-get update -y
apt-get upgrade -y
echo -e "${GREEN}✅ Sistema aggiornato${NC}"
echo ""

# 2. Installa Docker
echo -e "${BLUE}📦 Step 2/7: Installazione Docker...${NC}"
if ! command -v docker &> /dev/null; then
    # Installa dipendenze
    apt-get install -y ca-certificates curl gnupg lsb-release

    # Aggiungi Docker GPG key
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg

    # Aggiungi repository Docker
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Installa Docker
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Abilita Docker all'avvio
    systemctl enable docker
    systemctl start docker

    echo -e "${GREEN}✅ Docker installato${NC}"
else
    echo -e "${GREEN}✅ Docker già installato${NC}"
fi
echo ""

# 3. Installa Git
echo -e "${BLUE}📦 Step 3/7: Installazione Git...${NC}"
if ! command -v git &> /dev/null; then
    apt-get install -y git
    echo -e "${GREEN}✅ Git installato${NC}"
else
    echo -e "${GREEN}✅ Git già installato${NC}"
fi
echo ""

# 4. Crea directory applicazione
echo -e "${BLUE}📁 Step 4/7: Creazione directory applicazione...${NC}"
mkdir -p /opt/aulelibere
cd /opt/aulelibere
echo -e "${GREEN}✅ Directory creata: /opt/aulelibere${NC}"
echo ""

# 5. Clone repository
echo -e "${BLUE}📥 Step 5/7: Clone repository...${NC}"
if [ ! -d "/opt/aulelibere/.git" ]; then
    git clone https://github.com/mattiacolombomc/AuleLiberePoliMi.git .
    git checkout dev
    echo -e "${GREEN}✅ Repository clonato${NC}"
else
    git pull origin dev
    echo -e "${GREEN}✅ Repository aggiornato${NC}"
fi
echo ""

# 6. Crea file .env
echo -e "${BLUE}⚙️  Step 6/7: Configurazione variabili ambiente...${NC}"
echo -e "${YELLOW}Inserisci le variabili di ambiente:${NC}"
echo ""

read -p "TOKEN (bot token): " BOT_TOKEN
read -p "DEVELOPER_CHAT_ID: " DEV_CHAT_ID
read -p "CHANNEL_ID: " CHAN_ID
read -p "ADMIN_ID: " ADM_ID

cat > /opt/aulelibere/.env << EOF
TOKEN=${BOT_TOKEN}
DEVELOPER_CHAT_ID=${DEV_CHAT_ID}
CHANNEL_ID=${CHAN_ID}
ADMIN_ID=${ADM_ID}
USE_WEBHOOK=false
EOF

chmod 600 /opt/aulelibere/.env
echo -e "${GREEN}✅ File .env creato${NC}"
echo ""

# 7. Crea systemd service
echo -e "${BLUE}🔧 Step 7/7: Creazione systemd service...${NC}"
cat > /etc/systemd/system/aulelibere-bot.service << 'EOF'
[Unit]
Description=Aule Libere PoliMi Telegram Bot
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/aulelibere
ExecStartPre=/usr/bin/docker compose pull
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload
systemctl enable aulelibere-bot.service

echo -e "${GREEN}✅ Systemd service creato${NC}"
echo ""

# 8. Configura firewall (Oracle Cloud usa iptables)
echo -e "${BLUE}🔥 Configurazione firewall...${NC}"
# Oracle Cloud blocca le porte di default, non serve configurare nulla
# Il bot usa polling, non webhook, quindi non serve aprire porte
echo -e "${GREEN}✅ Firewall configurato (polling mode - no porte esterne)${NC}"
echo ""

echo -e "${GREEN}=================================================="
echo -e "🎉 SETUP COMPLETATO!"
echo -e "==================================================${NC}"
echo ""
echo "Per avviare il bot:"
echo "  sudo systemctl start aulelibere-bot"
echo ""
echo "Per vedere i logs:"
echo "  sudo docker compose logs -f"
echo ""
echo "Per fermare il bot:"
echo "  sudo systemctl stop aulelibere-bot"
echo ""
echo "Per riavviare il bot:"
echo "  sudo systemctl restart aulelibere-bot"
echo ""
echo "Il bot si avvierà automaticamente al riavvio della VM! 🚀"
echo ""
echo -e "${YELLOW}Vuoi avviare il bot ora? (y/n)${NC}"
read -p "> " START_NOW

if [ "$START_NOW" = "y" ] || [ "$START_NOW" = "Y" ]; then
    systemctl start aulelibere-bot
    echo ""
    echo -e "${GREEN}✅ Bot avviato!${NC}"
    echo ""
    echo "Logs in tempo reale:"
    docker compose logs -f
fi
