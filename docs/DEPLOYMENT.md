# Deployment Guide

This deployment is independent from LoyaltyPilot.

Do not connect this service to the existing LoyaltyPilot Render backend during this phase.

## 1. Create GitHub Repository

Create a new GitHub repository:

```text
evolution-api-host
```

From this directory:

```bash
git init
git add .
git commit -m "Initial Evolution API host deployment"
git branch -M main
git remote add origin https://github.com/YOUR_ORG/evolution-api-host.git
git push -u origin main
```

## 2. Connect Render

In Render:

1. Open Dashboard.
2. Click New.
3. Choose Blueprint.
4. Select the `evolution-api-host` repository.
5. Confirm the `render.yaml` plan.

Render will create:

- One Docker web service.
- One independent Postgres database.

## 3. Configure Required Environment Variables

Set these in the new Render Evolution service only.

Required:

```text
SERVER_URL=https://your-evolution-api-host.onrender.com
AUTHENTICATION_API_KEY=generate-a-long-random-secret
CORS_ORIGIN=https://your-loyaltypilot-web-domain.vercel.app
```

The `DATABASE_CONNECTION_URI` value is supplied by `render.yaml` from the new Render database.

Do not reuse LoyaltyPilot backend secrets.

## 4. Deploy

Before deploying from a local shell, validate required environment variables if you have exported them:

```bash
./scripts/validate-env.sh
```

Trigger the first deploy from Render.

Expected behavior:

- Render builds the Dockerfile.
- Docker pulls the official Evolution API image.
- Render starts the service on port `8080`.
- Health check path `/` becomes healthy.

## 5. Verify Health Endpoint

```bash
export EVOLUTION_API_URL=https://your-evolution-api-host.onrender.com
./scripts/verify-health.sh
```

Expected result:

```text
HTTP response body from Evolution API
```

No `401` is expected for the root health endpoint.

## 6. Verify API Authentication

Without API key:

```bash
curl -i "$EVOLUTION_API_URL/instance/fetchInstances"
```

Expected:

```text
401 or forbidden response
```

With API key:

```bash
curl -i "$EVOLUTION_API_URL/instance/fetchInstances" \
  -H "apikey: $EVOLUTION_API_KEY"
```

Expected:

```text
Authenticated response
```

## 7. Verify Instance Creation

```bash
export EVOLUTION_API_KEY=your-api-key
export INSTANCE_NAME=loyaltypilot_test_001
./scripts/create-instance.sh
```

Expected:

```text
JSON response containing the created instance and QR/pairing payload fields
```

## 8. Verify Pairing Code Generation

Pairing code or QR payload:

```bash
./scripts/get-pairing-code.sh
```

If your Evolution API version requires a phone number for pairing code:

```bash
export PHONE_NUMBER=919999999999
./scripts/get-pairing-code.sh
```

Expected:

```text
JSON response from /instance/connect/:instance
```

## 9. Verify Connection Status

```bash
./scripts/connection-status.sh
```

Expected statuses may include:

```text
connecting
open
close
```

## 10. Delete Test Instance

```bash
./scripts/delete-instance.sh
```

This prevents test instances from staying in the database.
