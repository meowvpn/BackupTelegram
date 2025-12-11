#!/bin/bash

REPO_URL="https://raw.githubusercontent.com/meowvpn/BackupTelegram/main"

echo "======================================"
echo " INSTALANDO SISTEMA DE BACKUP TELEGRAM "
echo "======================================"
sleep 1

cd /root

echo "[1/3] Baixando arquivos..."
curl -s -O $REPO_URL/backup_telegram.sh
curl -s -O $REPO_URL/configurar_backup.sh

echo "[2/3] Aplicando permissões..."
chmod +x /root/backup_telegram.sh
chmod +x /root/configurar_backup.sh

echo "[3/3] Instalação concluída!"
echo ""
echo "Agora configure o intervalo de backup com:"
echo "  /root/configurar_backup.sh"
echo ""
echo "E execute um backup de teste com:"
echo "  /root/backup_telegram.sh"
