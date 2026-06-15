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

if [ "${PHONE_NUMBER:-}" ]; then
  CONNECT_URL="$BASE_URL/instance/connect/$INSTANCE_NAME?number=$PHONE_NUMBER"
else
  CONNECT_URL="$BASE_URL/instance/connect/$INSTANCE_NAME"
fi

curl -fsS "$CONNECT_URL" \
  -H "apikey: $EVOLUTION_API_KEY"
printf '\n'
