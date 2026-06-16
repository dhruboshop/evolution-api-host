#!/bin/sh
set -eu

: "${EVOLUTION_API_URL:?Set EVOLUTION_API_URL, for example https://wa.zappy.rest}"

BASE_URL="${EVOLUTION_API_URL%/}"

curl -fsS "$BASE_URL/"
printf '\n'
