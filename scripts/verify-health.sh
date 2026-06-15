#!/usr/bin/env sh
set -eu

: "${EVOLUTION_API_URL:?Set EVOLUTION_API_URL, for example https://your-evolution-api-host.onrender.com}"

curl -fsS "$EVOLUTION_API_URL/"
printf '\n'

