#!/bin/bash

# Cores estilo SSHPLUS
verde="\e[32m"
vermelho="\e[31m"
amarelo="\e[33m"
azul="\e[34m"
reset="\e[0m"

CONFIG_FILE="/root/.backtel.conf"

# Carrega hora configurada
if [ -f "$CONFIG_FILE" ]; then
    TEMPO=$(cat "$CONFIG_FILE")
else
    TEMPO="Não configurado"
fi

# Verifica se está ativo
ATIVO=$(crontab -l | grep "backup_telegram.sh" >/dev/null && echo "Ativado" || echo "Desativado")

menu() {
clear
echo -e "${azul}=============================================${reset}"
echo -e "${verde}        SISTEMA DE BACKUP TELEGRAM${reset}"
echo -e "${azul}=============================================${reset}"
echo -e ""
echo -e " Status do Backup: ${amarelo}$ATIVO${reset}"
echo -e " Tempo Atual: ${amarelo}$TEMPO horas${reset}"
echo -e ""
echo -e "${verde}1)${reset} Ativar / Desativar Backup"
echo -e "${verde}2)${reset} Configurar Tempo do Backup"
echo -e "${verde}3)${reset} Criar Backup Agora"
echo -e "${verde}0)${reset} Sair"
echo -e ""
read -p "Escolha uma opção: " opcao

case $opcao in
    1) ativar_desativar ;;
    2) configurar_tempo ;;
    3) criar_backup ;;
    0) exit ;;
    *) echo "Opção inválida!"; sleep 1; menu ;;
esac
}

ativar_desativar() {
if [ "$ATIVO" = "Ativado" ]; then
    crontab -l | grep -v "backup_telegram.sh" | crontab -
    ATIVO="Desativado"
    echo -e "${vermelho}Backup desativado!${reset}"
else
    echo -e "${amarelo}Informe seu BOT TOKEN do Telegram:${reset}"
    read BOT
    echo -e "${amarelo}Informe seu CHAT ID:${reset}"
    read CHAT

    sed -i "s/BOT_TOKEN=.*/BOT_TOKEN=\"$BOT\"/g" /root/backup_telegram.sh
    sed -i "s/CHAT_ID=.*/CHAT_ID=\"$CHAT\"/g" /root/backup_telegram.sh

    configurar_tempo

    ATIVO="Ativado"
    echo -e "${verde}Backup ativado!${reset}"
fi
sleep 2
menu
}

configurar_tempo() {
clear
echo -e "${amarelo}Digite o intervalo em horas para execução do backup:${reset}"
read horas

if ! [[ "$horas" =~ ^[0-9]+$ ]]; then
    echo -e "${vermelho}Valor inválido!${reset}"
    sleep 1
    menu
fi

echo "$horas" > "$CONFIG_FILE"
TEMPO=$horas

# Remove cron antigo
crontab -l | grep -v "backup_telegram.sh" > /tmp/cron_temp

# Adiciona novo
echo "0 */$horas * * * /root/backup_telegram.sh > /dev/null 2>&1" >> /tmp/cron_temp
crontab /tmp/cron_temp
rm -f /tmp/cron_temp

echo -e "${verde}Tempo configurado para $horas horas.${reset}"
sleep 2
menu
}

criar_backup() {
clear
echo -e "${verde}Gerando backup agora...${reset}"
/root/backup_telegram.sh
echo -e "${verde}Backup enviado!${reset}"
sleep 2
menu
}

menu