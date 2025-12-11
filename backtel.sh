#!/bin/bash

# ===== Cores estilo SSHPLUS =====
verde="\e[32m"
vermelho="\e[31m"
amarelo="\e[33m"
azul="\e[34m"
reset="\e[0m"

BT_DIR="/root/backtel"
CONFIG_FILE="$BT_DIR/.tempo.conf"
LOCAIS_FILE="$BT_DIR/locais.txt"

# Garante arquivo de locais
[ ! -f "$LOCAIS_FILE" ] && touch "$LOCAIS_FILE"

# Tempo configurado
if [ -f "$CONFIG_FILE" ]; then
    TEMPO=$(cat "$CONFIG_FILE")
else
    TEMPO="Não configurado"
fi

# Status ativado?
ATIVO=$(crontab -l | grep "backup_telegram.sh" >/dev/null && echo "Ativado" || echo "Desativado")

menu() {
clear
echo -e "${azul}=============================================${reset}"
echo -e "${verde}        SISTEMA DE BACKUP TELEGRAM${reset}"
echo -e "${azul}=============================================${reset}"
echo ""
echo -e " Status do Backup: ${amarelo}$ATIVO${reset}"
echo -e " Intervalo: ${amarelo}$TEMPO horas${reset}"
echo ""
echo -e "${verde}1)${reset} Ativar / Desativar Backup"
echo -e "${verde}2)${reset} Configurar Tempo do Backup"
echo -e "${verde}3)${reset} Criar Backup Agora"
echo -e "${verde}4)${reset} Gerenciar Locais de Backup"
echo -e "${verde}0)${reset} Sair"
echo ""
read -p "Escolha uma opção: " opcao

case $opcao in
    1) ativar_desativar ;;
    2) configurar_tempo ;;
    3) criar_backup ;;
    4) gerenciar_locais ;;
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
    echo -e "${amarelo}Informe o BOT TOKEN:${reset}"
    read BOT
    echo -e "${amarelo}Informe o CHAT ID:${reset}"
    read CHAT

    sed -i "s/BOT_TOKEN=.*/BOT_TOKEN=\"$BOT\"/" $BT_DIR/backup_telegram.sh
    sed -i "s/CHAT_ID=.*/CHAT_ID=\"$CHAT\"/" $BT_DIR/backup_telegram.sh

    configurar_tempo
    ATIVO="Ativado"
    echo -e "${verde}Backup ativado!${reset}"
fi
sleep 2
menu
}

configurar_tempo() {
echo -e "${amarelo}Digite o intervalo em horas:${reset}"
read horas

if ! [[ "$horas" =~ ^[0-9]+$ ]]; then
    echo -e "${vermelho}Valor inválido!${reset}"
    sleep 1
    menu
fi

echo "$horas" > "$CONFIG_FILE"
TEMPO=$horas

crontab -l | grep -v "backup_telegram.sh" > /tmp/cron_temp
echo "0 */$horas * * * /root/backtel/backup_telegram.sh >/dev/null 2>&1" >> /tmp/cron_temp
crontab /tmp/cron_temp

rm -f /tmp/cron_temp

echo -e "${verde}Tempo configurado!${reset}"
sleep 2
menu
}

criar_backup() {
echo -e "${verde}Gerando backup...${reset}"
/root/backtel/backup_telegram.sh
echo -e "${verde}Backup enviado e removido da VPS!${reset}"
sleep 2
menu
}

gerenciar_locais() {
clear
echo -e "${azul}===== LOCAIS ATUAIS DE BACKUP =====${reset}"
cat -n "$LOCAIS_FILE"
echo ""
echo -e "${verde}1)${reset} Adicionar local"
echo -e "${verde}2)${reset} Remover local"
echo -e "${verde}0)${reset} Voltar"
read -p "Escolha: " op

case $op in
    1)
        read -p "Digite o caminho da pasta/arquivo: " local
        echo "$local" >> "$LOCAIS_FILE"
        echo -e "${verde}Adicionado!${reset}"
        sleep 1
        gerenciar_locais
    ;;
    2)
        read -p "Número para remover: " numero
        sed -i "${numero}d" "$LOCAIS_FILE"
        echo -e "${vermelho}Removido!${reset}"
        sleep 1
        gerenciar_locais
    ;;
    0) menu ;;
    *) gerenciar_locais ;;
esac
}

menu