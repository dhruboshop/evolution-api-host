# Verification Checklist

Use this checklist after every deployment.

## Required Local Variables

```bash
export EVOLUTION_API_URL=https://your-evolution-api-host.onrender.com
export EVOLUTION_API_KEY=your-api-key
export INSTANCE_NAME=loyaltypilot_verify
```

Optional:

```bash
export PHONE_NUMBER=919999999999
```

## 1. Health Endpoint

```bash
./scripts/verify-health.sh
```

Pass criteria:

- Request completes with HTTP 2xx.
- Render service shows healthy.

## 2. Create Instance

```bash
./scripts/create-instance.sh
```

Pass criteria:

- HTTP 2xx.
- JSON response contains instance data.

## 3. Get Pairing Code Or QR Payload

```bash
./scripts/get-pairing-code.sh
```

Pass criteria:

- HTTP 2xx.
- Response contains connect, QR, pairing, or code payload depending on the Evolution API version.

## 4. Connection Status

```bash
./scripts/connection-status.sh
```

Pass criteria:

- HTTP 2xx.
- Response contains the instance connection state.

## 5. Delete Instance

```bash
./scripts/delete-instance.sh
```

Pass criteria:

- HTTP 2xx or successful deletion response.
- Re-running status for the same instance should show missing/closed/deleted behavior.

## One-command Verification

```bash
./scripts/verify-all.sh
```

This command:

1. Checks health.
2. Creates an instance.
3. Requests pairing code or QR payload.
4. Checks connection status.
5. Deletes the test instance.

