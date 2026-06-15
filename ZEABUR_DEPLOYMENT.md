# Zeabur Deployment Guide

This guide deploys Evolution API as a standalone Zeabur service named:

```text
loyaltypilot-evolution
```

It does not change LoyaltyPilot, Vercel, Supabase, or any existing Render service.

## Compatibility Audit

The repository is compatible with Zeabur Git deployments because:

- `Dockerfile` uses the official Evolution API image wrapper.
- The container listens on `8080`.
- Zeabur can deploy repositories that contain a `Dockerfile`.
- Zeabur Docker services require an explicit public HTTP port; use `8080`.
- Evolution API stores WhatsApp instance credentials under `/evolution/instances`.
- Zeabur supports volumes for persistent service directories.

Risk areas to check during deployment:

- Missing `DATABASE_CONNECTION_URI` prevents Evolution startup.
- Wrong public port prevents health checks and pairing requests.
- No volume at `/evolution/instances` can cause WhatsApp sessions to disappear after restart.
- Free or low-resource deployments may sleep, restart, or run out of memory during multiple active sessions.

## Recommended MVP Architecture On Zeabur

Use one Zeabur service for Evolution API and one Postgres database.

```text
GitHub repository
  -> Zeabur Docker service
      -> Evolution API container on port 8080
      -> Volume mounted at /evolution/instances
      -> Postgres connection through DATABASE_CONNECTION_URI
```

For first MVP validation, use Zeabur Postgres if available in your Zeabur project. If you must use the existing Supabase Postgres project, use a separate schema and do not use LoyaltyPilot application tables.

## Required Environment Variables

Set these in Zeabur service variables.

```text
SERVER_NAME=loyaltypilot-evolution
SERVER_TYPE=http
SERVER_PORT=8080
SERVER_URL=${ZEABUR_WEB_URL}

AUTHENTICATION_API_KEY=<generate-a-long-random-secret>
AUTHENTICATION_EXPOSE_IN_FETCH_INSTANCES=false

DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_URI=<postgres-connection-string>
DATABASE_CONNECTION_CLIENT_NAME=loyaltypilot_evolution

DATABASE_SAVE_DATA_INSTANCE=true
DATABASE_SAVE_DATA_NEW_MESSAGE=true
DATABASE_SAVE_MESSAGE_UPDATE=true
DATABASE_SAVE_DATA_CONTACTS=true
DATABASE_SAVE_DATA_CHATS=true
DATABASE_SAVE_DATA_LABELS=false
DATABASE_SAVE_DATA_HISTORIC=false
DATABASE_SAVE_IS_ON_WHATSAPP=true
DATABASE_SAVE_IS_ON_WHATSAPP_DAYS=7
DATABASE_DELETE_MESSAGE=false
DEL_INSTANCE=false

CACHE_REDIS_ENABLED=false
CACHE_LOCAL_ENABLED=true

CORS_ORIGIN=<your-allowed-origin>
CORS_METHODS=GET,POST,PUT,DELETE
CORS_CREDENTIALS=true

LOG_LEVEL=ERROR,WARN,INFO,LOG
LOG_COLOR=false
LOG_BAILEYS=error
LANGUAGE=en

CONFIG_SESSION_PHONE_CLIENT=LoyaltyPilot
CONFIG_SESSION_PHONE_NAME=Chrome
QRCODE_LIMIT=30
QRCODE_COLOR=#146c5f

TELEMETRY_ENABLED=false
PROMETHEUS_METRICS=false
WEBSOCKET_ENABLED=false
WEBHOOK_GLOBAL_ENABLED=false
RABBITMQ_ENABLED=false
SQS_ENABLED=false
PUSHER_ENABLED=false
KAFKA_ENABLED=false
TYPEBOT_ENABLED=false
CHATWOOT_ENABLED=false
OPENAI_ENABLED=false
DIFY_ENABLED=false
EVOAI_ENABLED=false
S3_ENABLED=false
```

### Required Variables

| Variable | Required | Notes |
| --- | --- | --- |
| `SERVER_NAME` | Yes | Human-readable service name. |
| `SERVER_TYPE` | Yes | Use `http`. |
| `SERVER_PORT` | Yes | Use `8080`; match Dockerfile `EXPOSE 8080`. |
| `SERVER_URL` | Yes | Use `${ZEABUR_WEB_URL}` after the Zeabur domain exists, or paste the generated HTTPS URL. |
| `AUTHENTICATION_API_KEY` | Yes | Long random secret. Never commit it. |
| `DATABASE_PROVIDER` | Yes | Use `postgresql` for MVP. |
| `DATABASE_CONNECTION_URI` | Yes | Zeabur Postgres or Supabase Session Pooler URI. |
| `DATABASE_CONNECTION_CLIENT_NAME` | Yes | Use `loyaltypilot_evolution`. |
| `CORS_ORIGIN` | Yes | Use the future LoyaltyPilot web origin or a temporary admin origin for validation. Do not use `*` in production. |

### Optional Variables

All `DATABASE_SAVE_*`, `CACHE_*`, log, webhook, queue, AI, and integration flags above are optional in the sense that defaults exist, but set them explicitly for production clarity.

## Storage Analysis

Evolution API's official Docker Compose mounts:

```text
/evolution/instances
```

This directory stores WhatsApp instance/session files used by the Baileys connection layer. Mount a Zeabur Volume exactly at:

```text
/evolution/instances
```

If the Zeabur volume is available:

1. Open the Evolution service in Zeabur.
2. Go to the Volumes tab.
3. Add a volume.
4. Volume ID:

   ```text
   evolution-instances
   ```

5. Mount Directory:

   ```text
   /evolution/instances
   ```

If a volume cannot be configured on your current Zeabur plan, sessions may be lost after redeploy, restart, or sleep. The practical result is that merchants may need to scan or enter a new pairing code again.

## Supabase Database Option

Evolution metadata can use Supabase Postgres, but use it only if you accept that Evolution will create and migrate its own tables.

Do not put Evolution tables in the same schema as LoyaltyPilot application tables.

Preferred Supabase format:

```text
postgresql://postgres.<project-ref>:<database-password>@aws-<region>.pooler.supabase.com:5432/postgres?schema=evolution_api
```

Use the Supabase Session Pooler on port `5432` for broad IPv4 compatibility. Avoid the Transaction Pooler on port `6543` for Evolution startup migrations unless you have verified Prisma migration compatibility for your project.

Before using this option, create the schema once in Supabase SQL editor:

```sql
create schema if not exists evolution_api;
```

This is the only manual SQL required for the shared Supabase option. For a fully isolated MVP, use a separate Zeabur Postgres database instead.

## Zeabur Deployment Procedure

1. Log in to Zeabur.
2. Create a new project.
3. Choose a region close to your first merchants.
4. Click Add Service.
5. Choose GitHub.
6. Select:

   ```text
   dhruboshop/evolution-api-host
   ```

7. Confirm Zeabur detects the `Dockerfile`.
8. Set the service name:

   ```text
   loyaltypilot-evolution
   ```

9. Configure public networking:

   ```text
   Port Name: web
   Port: 8080
   Port Type: HTTP
   ```

10. Generate a Zeabur domain for the `web` port.
11. Add the environment variables listed above.
12. Add a volume mounted at `/evolution/instances`.
13. Deploy.
14. Open logs and confirm Evolution starts without database migration errors.
15. Visit:

    ```text
    https://<your-zeabur-domain>/
    ```

16. Confirm the health endpoint returns HTTP `200`.

## Validation Tests

From your laptop:

```bash
export EVOLUTION_API_URL=https://<your-zeabur-domain>
export EVOLUTION_API_KEY=<AUTHENTICATION_API_KEY>
export INSTANCE_NAME=loyaltypilot_verify
```

### Test 1: Health Endpoint

```bash
./scripts/verify-health.sh
```

Expected:

```text
HTTP 200
```

### Test 2: API Authentication

Without key:

```bash
curl -i "$EVOLUTION_API_URL/instance/fetchInstances"
```

Expected:

```text
401 or 403
```

With key:

```bash
curl -i "$EVOLUTION_API_URL/instance/fetchInstances" \
  -H "apikey: $EVOLUTION_API_KEY"
```

Expected:

```text
Authenticated JSON response
```

### Test 3: Create Instance

```bash
./scripts/create-instance.sh
```

Expected:

```text
Instance created
```

### Test 4: Generate Pairing Code

```bash
export PHONE_NUMBER=919999999999
./scripts/get-pairing-code.sh
```

Expected:

```text
Pairing code or QR payload returned
```

### Test 5: Connect WhatsApp

Use the pairing code or QR payload in WhatsApp.

Then:

```bash
./scripts/connection-status.sh
```

Expected:

```text
Connected/open state
```

### Test 6: Restart Service

1. Restart the Zeabur service.
2. Wait for health check success.
3. Run:

   ```bash
   ./scripts/connection-status.sh
   ```

Expected with volume:

```text
Session remains connected or reconnects automatically
```

Expected without volume:

```text
Session may be missing, disconnected, or require pairing again
```

## Failure Analysis

If Zeabur sleeps:

- Incoming webhook delivery can fail while the service is asleep.
- Pairing status polling can fail.
- WhatsApp connection may drop.
- Merchant onboarding may appear stuck at "connecting".

If the volume is unavailable:

- `/evolution/instances` becomes ephemeral.
- WhatsApp session files can disappear.
- Merchants may need to reconnect WhatsApp after restart or redeploy.

If the service restarts:

- With volume and database: session should have the best chance to survive.
- Without volume: session persistence is not reliable.
- With local cache only: live connection state may need to rebuild after startup.

Impact on LoyaltyPilot later:

- Merchant onboarding must handle "reconnect required".
- Pairing codes expire and must be regenerated.
- Campaign sending must pause when instance status is not connected.

## Known Limitations For MVP

- Redis is disabled for this standalone validation to reduce moving parts.
- Free or low-resource Zeabur plans are not proven for 50 active merchant sessions.
- A volume is mandatory for any meaningful WhatsApp session persistence test.
- A separate Postgres database is safer than sharing the production LoyaltyPilot Supabase project.
- Do not connect this service to LoyaltyPilot until health, auth, instance creation, pairing, connection, and restart persistence are verified.

## References

- Zeabur Dockerfile deployment docs: https://zeabur.com/docs/en-US/deploy/methods/dockerfile
- Zeabur custom Docker image docs: https://zeabur.com/docs/en-US/deploy/methods/custom-docker-image
- Zeabur environment variable docs: https://zeabur.com/docs/en-US/deploy/config/environment-variables
- Zeabur volume docs: https://zeabur.com/docs/en-US/data-management/volumes
- Evolution API official Docker Compose: https://github.com/evolution-foundation/evolution-api/blob/main/docker-compose.yaml
- Evolution API database docs: https://docs.evolutionfoundation.com.br/en/evolution-api/requirements/database
- Supabase Postgres connection docs: https://supabase.com/docs/guides/database/connecting-to-postgres
