#!/usr/bin/env sh
set -eu

: "${EVOLUTION_API_URL:?Set EVOLUTION_API_URL}"
: "${EVOLUTION_API_KEY:?Set EVOLUTION_API_KEY}"
: "${INSTANCE_NAME:?Set INSTANCE_NAME}"

curl -fsS "$EVOLUTION_API_URL/instance/connectionState/$INSTANCE_NAME" \
  -H "apikey: $EVOLUTION_API_KEY"
printf '\n'

