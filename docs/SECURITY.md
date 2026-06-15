# Security Review

## Secrets

No secrets are committed.

Required secrets:

```text
AUTHENTICATION_API_KEY
DATABASE_CONNECTION_URI
SERVER_URL
```

Optional secrets:

```text
WEBHOOK_GLOBAL_URL
PROXY_USERNAME
PROXY_PASSWORD
S3_ACCESS_KEY
S3_SECRET_KEY
```

## API Authentication

Evolution API requires:

```text
apikey: <AUTHENTICATION_API_KEY>
```

The verification scripts send the API key only through headers.

## Public Instance Listing

Production default:

```text
AUTHENTICATION_EXPOSE_IN_FETCH_INSTANCES=false
```

This avoids exposing instance inventory through fetch endpoints.

## CORS

Production default:

```text
CORS_ORIGIN=https://your-loyaltypilot-web-domain.vercel.app
```

Do not use `*` in production.

## Disabled Integrations

The following are disabled by default:

- Redis
- RabbitMQ
- SQS
- Kafka
- Pusher
- Websocket
- Global webhook
- Typebot
- Chatwoot
- OpenAI
- Dify
- EvoAI
- S3

Enable only the integrations that are actually required.

## Render Isolation

Use a separate Render service and separate Render Postgres database.

Do not reuse:

- LoyaltyPilot backend service.
- LoyaltyPilot backend environment variables.
- LoyaltyPilot Supabase database.
- LoyaltyPilot Docker configuration.

## Pre-launch Security Checklist

- `AUTHENTICATION_API_KEY` is long and random.
- `.env` is not committed.
- `AUTHENTICATION_EXPOSE_IN_FETCH_INSTANCES=false`.
- `CORS_ORIGIN` is restricted.
- Render service logs contain no secrets.
- Test instances are deleted after verification.

