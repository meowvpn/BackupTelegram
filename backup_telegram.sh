#!/bin/bash

# ===== CONFIGURAÇÕES =====
BOT_TOKEN="7702327683:AAFDE78WLaUlced53963xy-zeMSXUqtA2JU"
CHAT_ID="5833273722"
DATA=$(date '+%Y-%m-%d_%H-%M')
BACKUP_DIR="/root/backup_temp"
BACKUP_FILE="/root/backup_$DATA.zip"

# Limpa pasta temporária
rm -rf "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# ===== COPIANDO ARQUIVOS =====
cp /usr/local/etc/xray/config.json "$BACKUP_DIR/" 2>/dev/null

mkdir -p "$BACKUP_DIR/BOTSSH"
cp -r /root/BOTSSH/* "$BACKUP_DIR/BOTSSH/" 2>/dev/null

# ===== GERANDO ZIP =====
cd "$BACKUP_DIR"
zip -r "$BACKUP_FILE" . >/dev/null

# ===== ENVIANDO PRO TELEGRAM =====
curl -F document=@"$BACKUP_FILE" \
     "https://api.telegram.org/bot$BOT_TOKEN/sendDocument?chat_id=$CHAT_ID&caption=Backup%20($DATA)"

rm -rf "$BACKUP_DIR"