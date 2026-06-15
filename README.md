# evolution-api-host

Independent Evolution API deployment repository for LoyaltyPilot.

This repository is intentionally separate from the LoyaltyPilot application repository.

It does not share:

- source files
- Docker configuration
- Render service configuration
- Supabase configuration
- Vercel configuration
- environment variables
- build process

## What This Deploys

This project deploys the official Evolution API Docker image:

```text
evoapicloud/evolution-api:v2.3.6
```

The Docker image tag is configurable through the `EVOLUTION_API_IMAGE` Docker build argument.

## Repository Structure

```text
evolution-api-host/
  Dockerfile
  docker-compose.yml
  render.yaml
  .env.example
  README.md
  scripts/
    validate-env.sh
    healthcheck.sh
    verify-health.sh
    create-instance.sh
    get-pairing-code.sh
    connection-status.sh
    delete-instance.sh
    verify-all.sh
  docs/
    DEPLOYMENT.md
    VERIFICATION.md
    ROLLBACK.md
    SECURITY.md
```

## Local Run

Local Docker is optional and is not required for LoyaltyPilot development.

```bash
cp .env.example .env
docker compose up --build
```

Health check:

```bash
EVOLUTION_API_URL=http://localhost:8080 ./scripts/verify-health.sh
```

## Render Deployment

Use `render.yaml` to create a completely independent Render Blueprint.

Required Render secrets:

```text
SERVER_URL
AUTHENTICATION_API_KEY
CORS_ORIGIN
```

Environment validation:

```bash
./scripts/validate-env.sh
```

Render provisions a separate Postgres database named:

```text
evolution-api-postgres
```

## Verification

Set:

```bash
export EVOLUTION_API_URL=https://your-evolution-api-host.onrender.com
export EVOLUTION_API_KEY=your-api-key
export INSTANCE_NAME=loyaltypilot_verify
```

Run:

```bash
./scripts/verify-all.sh
```

## Official References

- Evolution API Docker install docs: https://docs.evolution-api.com/v2/en/get-started/install/docker
- Evolution API environment example: https://github.com/evolution-foundation/evolution-api/blob/main/.env.example
