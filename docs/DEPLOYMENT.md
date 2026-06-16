# Deployment Guide

This guide deploys Evolution API as a new, independent Render service named:

```text
zappy-evolution
```

It does not change Zappy, Vercel, Supabase, or the existing Render backend.

## 1. Create Or Use The GitHub Repository

Repository:

```text
https://github.com/dhruboshop/evolution-api-host.git
```

Push this repository to `main`.

## 2. Create A Render Blueprint

In Render:

1. Open the Render dashboard.
2. Click New.
3. Choose Blueprint.
4. Select `dhruboshop/evolution-api-host`.
5. Confirm the services in `render.yaml`.

Render should create:

```text
zappy-evolution
zappy-evolution-postgres
```

## 3. Set Required Render Variables

Open the `zappy-evolution` web service and set:

```text
SERVER_URL=https://wa.zappy.rest
AUTHENTICATION_API_KEY=<generate-a-long-random-secret>
CORS_ORIGIN=https://zappy.rest
```

Do not use quotes around values in Render.

Do not reuse the Zappy backend API key or any Supabase key.

## 4. Confirm Database Variable

`render.yaml` wires:

```text
DATABASE_CONNECTION_URI
```

from:

```text
zappy-evolution-postgres
```

If Render asks you to enter it manually, copy the internal database connection string from the new Evolution Postgres database only.

## 5. Deploy

Trigger a manual deploy after environment variables are set.

Expected startup:

1. Docker pulls `evoapicloud/evolution-api:latest`.
2. Evolution API starts on port `8080`.
3. Render health check calls `/`.
4. Service becomes healthy.

## 6. Verify Health

From your laptop:

```bash
export EVOLUTION_API_URL=https://wa.zappy.rest
./scripts/verify-health.sh
```

Pass result:

```text
HTTP 2xx response
```

## 7. Verify API Authentication

Without the API key:

```bash
curl -i "$EVOLUTION_API_URL/instance/fetchInstances"
```

Expected:

```text
Unauthorized or forbidden response
```

With the API key:

```bash
export EVOLUTION_API_KEY=<same value as AUTHENTICATION_API_KEY>
curl -i "$EVOLUTION_API_URL/instance/fetchInstances" \
  -H "apikey: $EVOLUTION_API_KEY"
```

Expected:

```text
Authenticated JSON response
```

## 8. Verify Instance Creation

```bash
export INSTANCE_NAME=zappy_verify
./scripts/create-instance.sh
```

Expected:

```text
JSON response from /instance/create
```

## 9. Verify Pairing Code Or QR Payload

```bash
./scripts/get-pairing-code.sh
```

If your Evolution API deployment requires a phone number for pairing code:

```bash
export PHONE_NUMBER=919999999999
./scripts/get-pairing-code.sh
```

Expected:

```text
JSON response from /instance/connect/:instance
```

## 10. Verify Connection Status

```bash
./scripts/connection-status.sh
```

Expected:

```text
JSON response from /instance/connectionState/:instance
```

## 11. Delete Test Instance

```bash
./scripts/delete-instance.sh
```

This keeps the new Evolution database clean.
