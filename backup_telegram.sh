#!/bin/bash

BOT_TOKEN="TOKEN_AQUI"
CHAT_ID="CHAT_AQUI"

BT_DIR="/root/backtel"
LOCAIS="$BT_DIR/locais.txt"

DATA=$(date '+%Y-%m-%d_%H-%M')
TEMP_DIR="$BT_DIR/temp"
ZIP_FILE="$BT_DIR/backup_$DATA.zip"

rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Copia todos os locais configurados
while read caminho; do
    [ -z "$caminho" ] && continue
    if [ -f "$caminho" ]; then
        cp "$caminho" "$TEMP_DIR/"
    elif [ -d "$caminho" ]; then
        cp -r "$caminho" "$TEMP_DIR/"
    fi
done < "$LOCAIS"

# Compacta tudo
cd "$TEMP_DIR"
zip -r "$ZIP_FILE" . >/dev/null

# Envia ao Telegram
curl -F document=@"$ZIP_FILE" \
"https://api.telegram.org/bot$BOT_TOKEN/sendDocument?chat_id=$CHAT_ID&caption=Backup%20($DATA)"

# Remove backup após enviar
rm -rf "$TEMP_DIR"
rm -f "$ZIP_FILE"