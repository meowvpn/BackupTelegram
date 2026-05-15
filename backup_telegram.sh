#!/bin/bash

BOT_TOKEN="TOKEN_AQUI"
CHAT_ID="CHAT_AQUI"

BT_DIR="/root/backtel"
LOCAIS="$BT_DIR/locais.txt"

TEMP_DIR="$BT_DIR/temp"
ZIP_FILE="$BT_DIR/VPS_1.zip"

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
RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" \
-F chat_id="$CHAT_ID" \
-F caption="♻️ BACKUP AUTOMATICO" \
-F document=@"$ZIP_FILE")

echo "$RESPONSE"

# Remove apenas se enviou
if echo "$RESPONSE" | grep -q '"ok":true'; then
    echo "Backup enviado com sucesso!"
    rm -rf "$TEMP_DIR"
    rm -f "$ZIP_FILE"
else
    echo "Erro ao enviar backup!"
fi
