#!/bin/bash

REPO="https://raw.githubusercontent.com/meowvpn/BackupTelegram/main"

echo "Instalando dependências..."
apt install zip -y >/dev/null

echo "Baixando arquivos..."
curl -s -O $REPO/backup_telegram.sh
curl -s -O $REPO/backtel.sh

chmod +x /root/backup_telegram.sh
chmod +x /root/backtel.sh

# Criar comando global "backtel"
ln -sf /root/backtel.sh /usr/bin/backtel

echo "Instalação concluída!"
echo "Execute: backtel"