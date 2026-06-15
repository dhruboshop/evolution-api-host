#!/usr/bin/env sh
set -eu

: "${EVOLUTION_API_URL:?Set EVOLUTION_API_URL}"
: "${EVOLUTION_API_KEY:?Set EVOLUTION_API_KEY}"
: "${INSTANCE_NAME:?Set INSTANCE_NAME}"

case "$INSTANCE_NAME" in
  *[!A-Za-z0-9_-]*)
    echo "INSTANCE_NAME may contain only letters, numbers, underscores, and hyphens." >&2
    exit 1
    ;;
esac

BASE_URL="${EVOLUTION_API_URL%/}"

curl -fsS -X DELETE "$BASE_URL/instance/logout/$INSTANCE_NAME" \
  -H "apikey: $EVOLUTION_API_KEY" || true
printf '\n'

curl -fsS -X DELETE "$BASE_URL/instance/delete/$INSTANCE_NAME" \
  -H "apikey: $EVOLUTION_API_KEY"
printf '\n'
