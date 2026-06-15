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

case "$AUTHENTICATION_API_KEY" in
  replace*|changeme|change-me|test|secret)
    echo "AUTHENTICATION_API_KEY must be a real random secret, not a placeholder." >&2
    exit 1
    ;;
esac

if [ "${#AUTHENTICATION_API_KEY}" -lt 32 ]; then
  echo "AUTHENTICATION_API_KEY must be at least 32 characters." >&2
  exit 1
fi

case "$SERVER_URL" in
  http://localhost*|http://127.0.0.1*)
    echo "SERVER_URL must be the public Render HTTPS URL in production." >&2
    exit 1
    ;;
esac

case "$CORS_ORIGIN" in
  "*"|"")
    echo "CORS_ORIGIN must be restricted to the LoyaltyPilot web origin in production." >&2
    exit 1
    ;;
esac

echo "Required Evolution API environment variables are present."
