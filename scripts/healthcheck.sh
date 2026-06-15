#!/usr/bin/env sh
set -eu

BASE_URL="${EVOLUTION_API_URL:-http://127.0.0.1:${SERVER_PORT:-8080}}"
BASE_URL="${BASE_URL%/}"

curl -fsS "$BASE_URL/" >/dev/null
echo "Evolution API health check passed: $BASE_URL/"
