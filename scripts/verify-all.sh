#!/bin/sh
set -eu

: "${EVOLUTION_API_URL:?Set EVOLUTION_API_URL}"
: "${EVOLUTION_API_KEY:?Set EVOLUTION_API_KEY}"
: "${INSTANCE_NAME:=loyaltypilot_verify_$(date +%s)}"
export INSTANCE_NAME

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

echo "1. Health"
"$SCRIPT_DIR/verify-health.sh" >/dev/null
echo "OK"

echo "2. Create instance: $INSTANCE_NAME"
"$SCRIPT_DIR/create-instance.sh" >/tmp/evolution-create-instance.json
echo "OK"

echo "3. Get pairing code / QR payload"
"$SCRIPT_DIR/get-pairing-code.sh" >/tmp/evolution-pairing-code.json
echo "OK"

echo "4. Connection status"
"$SCRIPT_DIR/connection-status.sh" >/tmp/evolution-connection-status.json
echo "OK"

echo "5. Delete instance"
"$SCRIPT_DIR/delete-instance.sh" >/tmp/evolution-delete-instance.json
echo "OK"

echo "Verification complete for $EVOLUTION_API_URL"
