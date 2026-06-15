# Security Review

## Isolation

This repository is separate from LoyaltyPilot.

Do not share:

- Render service.
- Render database.
- Supabase keys.
- Vercel variables.
- LoyaltyPilot backend variables.

## Secrets

No secrets belong in git.

Required production secrets:

```text
AUTHENTICATION_API_KEY
DATABASE_CONNECTION_URI
SERVER_URL
CORS_ORIGIN
```

`DATABASE_CONNECTION_URI` is provided by Render from the dedicated Evolution database.

## API Key Protection

All protected Evolution API calls must send:

```text
apikey: <AUTHENTICATION_API_KEY>
```

Rules:

- Minimum 32 characters.
- Randomly generated.
- Stored only in Render or local shell during verification.
- Rotated if exposed.

## Instance Inventory

Production default:

```text
AUTHENTICATION_EXPOSE_IN_FETCH_INSTANCES=false
```

This reduces public visibility of instance inventory.

## CORS

Production default:

```text
CORS_ORIGIN=<your LoyaltyPilot web origin>
```

Do not use:

```text
CORS_ORIGIN=*
```

## Persistent Storage

Render disk is mounted at:

```text
/evolution/instances
```

This keeps WhatsApp instance data separate from the application image.

## Disabled Optional Services

Disabled by default:

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

Enable only after a separate review.

## Pre-launch Security Checklist

- `.env` is not committed.
- `AUTHENTICATION_API_KEY` is random and at least 32 characters.
- `AUTHENTICATION_EXPOSE_IN_FETCH_INSTANCES=false`.
- `CORS_ORIGIN` is restricted.
- Render database is dedicated to Evolution API.
- Render disk is dedicated to Evolution API.
- Test instances are deleted after verification.

