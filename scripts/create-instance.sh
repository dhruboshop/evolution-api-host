#!/usr/bin/env sh
set -eu

: "${EVOLUTION_API_URL:?Set EVOLUTION_API_URL}"
: "${EVOLUTION_API_KEY:?Set EVOLUTION_API_KEY}"
: "${INSTANCE_NAME:?Set INSTANCE_NAME}"

curl -fsS -X POST "$EVOLUTION_API_URL/instance/create" \
  -H "Content-Type: application/json" \
  -H "apikey: $EVOLUTION_API_KEY" \
  -d "{\"instanceName\":\"$INSTANCE_NAME\",\"qrcode\":true,\"integration\":\"WHATSAPP-BAILEYS\"}"
printf '\n'

