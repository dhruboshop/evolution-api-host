#!/usr/bin/env sh
set -eu

: "${EVOLUTION_API_URL:?Set EVOLUTION_API_URL}"
: "${EVOLUTION_API_KEY:?Set EVOLUTION_API_KEY}"
: "${INSTANCE_NAME:?Set INSTANCE_NAME}"

if [ "${PHONE_NUMBER:-}" ]; then
  CONNECT_URL="$EVOLUTION_API_URL/instance/connect/$INSTANCE_NAME?number=$PHONE_NUMBER"
else
  CONNECT_URL="$EVOLUTION_API_URL/instance/connect/$INSTANCE_NAME"
fi

curl -fsS "$CONNECT_URL" \
  -H "apikey: $EVOLUTION_API_KEY"
printf '\n'

