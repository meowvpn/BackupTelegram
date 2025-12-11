#!/bin/bash

echo "======================================"
echo " CONFIGURAR BACKUP AUTOMÁTICO "
echo "======================================"
echo ""
echo "De quantas em quantas horas deseja fazer o backup?"
read -p "Digite o número de horas (ex: 2): " HORAS

if ! [[ "$HORAS" =~ ^[0-9]+$ ]]; then
    echo "Erro: digite apenas números!"
    exit 1
fi

crontab -l | grep -v "backup_telegram.sh" > /tmp/cron_temp

echo "0 */$HORAS * * * /root/backup_telegram.sh >/dev/null 2>&1" >> /tmp/cron_temp

crontab /tmp/cron_temp
rm -f /tmp/cron_temp

echo ""
echo "Backup configurado para rodar a cada $HORAS horas!"
echo "Use 'crontab -l' para conferir."