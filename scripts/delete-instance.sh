#!/usr/bin/env sh
set -eu

: "${EVOLUTION_API_URL:?Set EVOLUTION_API_URL}"
: "${EVOLUTION_API_KEY:?Set EVOLUTION_API_KEY}"
: "${INSTANCE_NAME:?Set INSTANCE_NAME}"

curl -fsS -X DELETE "$EVOLUTION_API_URL/instance/logout/$INSTANCE_NAME" \
  -H "apikey: $EVOLUTION_API_KEY" || true
printf '\n'

curl -fsS -X DELETE "$EVOLUTION_API_URL/instance/delete/$INSTANCE_NAME" \
  -H "apikey: $EVOLUTION_API_KEY"
printf '\n'

