#!/usr/bin/env sh
set -eu

required_vars="
SERVER_URL
AUTHENTICATION_API_KEY
DATABASE_PROVIDER
DATABASE_CONNECTION_URI
DATABASE_CONNECTION_CLIENT_NAME
CORS_ORIGIN
"

missing=""

for key in $required_vars; do
  value="$(printenv "$key" || true)"
  if [ -z "$value" ]; then
    missing="$missing $key"
  fi
done

if [ -n "$missing" ]; then
  echo "Missing required environment variables:$missing" >&2
  exit 1
fi

echo "Required Evolution API environment variables are present."

