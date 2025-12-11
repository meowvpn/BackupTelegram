#!/bin/bash

REPO="https://raw.githubusercontent.com/meowvpn/BackupTelegram/main"

echo "Instalando dependências..."
apt install zip -y >/dev/null

mkdir -p /root/backtel
cd /root/backtel

echo "Baixando arquivos..."
curl -s -O $REPO/backtel.sh
curl -s -O $REPO/backup_telegram.sh

echo "" > locais.txt

chmod +x backtel.sh
chmod +x backup_telegram.sh

# Comando global
ln -sf /root/backtel/backtel.sh /usr/bin/backtel

echo "Instalação concluída!"
echo "Use: backtel"