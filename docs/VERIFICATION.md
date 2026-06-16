# Verification Checklist

Run this after every deployment.

## Setup

```bash
export EVOLUTION_API_URL=https://wa.zappy.rest
export EVOLUTION_API_KEY=<AUTHENTICATION_API_KEY from Render>
export INSTANCE_NAME=zappy_verify
```

Optional:

```bash
export PHONE_NUMBER=919999999999
```

## One-command Verification

```bash
./scripts/verify-all.sh
```

This verifies:

1. Health endpoint.
2. Instance creation.
3. Pairing code or QR payload.
4. Connection status.
5. Instance deletion.

## Manual Verification

Health:

```bash
./scripts/verify-health.sh
```

Create instance:

```bash
./scripts/create-instance.sh
```

Get pairing code or QR:

```bash
./scripts/get-pairing-code.sh
```

Connection status:

```bash
./scripts/connection-status.sh
```

Delete test instance:

```bash
./scripts/delete-instance.sh
```

## Pass Criteria

- Health endpoint returns HTTP 2xx.
- Authenticated API requests with `apikey` succeed.
- Unauthenticated API requests fail.
- Test instance can be created.
- Pairing endpoint returns JSON.
- Connection status endpoint returns JSON.
- Test instance can be deleted.

## Common Failures

If health fails:

- Check Render deploy logs.
- Confirm the service is listening on port `8080`.
- Confirm `DATABASE_CONNECTION_URI` exists.

If API calls fail with unauthorized:

- Confirm `EVOLUTION_API_KEY` in your shell equals `AUTHENTICATION_API_KEY` in Render.

If instance creation fails:

- Confirm the Render Postgres database is healthy.
- Confirm persistent disk is mounted at `/evolution/instances`.

