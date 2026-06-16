# evolution-api-host

Independent Evolution API deployment repository for Zappy.

This repository deploys a separate WhatsApp Evolution API service. It must stay separate from the Zappy application repository and from the existing Zappy Render backend.

## What This Repository Deploys

- Zeabur Docker service: `zappy-evolution`
- Optional Render Docker web service: `zappy-evolution`
- Official Evolution API image: `evoapicloud/evolution-api:latest`
- Health check endpoint: `/`
- API authentication: `apikey` header using `AUTHENTICATION_API_KEY`
- Persistent instance storage: `/evolution/instances`

## Repository Structure

```text
evolution-api-host/
  Dockerfile
  docker-compose.yml
  render.yaml
  .env.example
  README.md
  ZEABUR_DEPLOYMENT.md
  docs/
    DEPLOYMENT.md
    VERIFICATION.md
    ROLLBACK.md
    SECURITY.md
  scripts/
    validate-env.sh
    healthcheck.sh
    verify-health.sh
    create-instance.sh
    get-pairing-code.sh
    connection-status.sh
    delete-instance.sh
    verify-all.sh
```

## Required Zeabur Environment Variables

Set these in the new Zeabur service only:

```text
SERVER_URL
AUTHENTICATION_API_KEY
DATABASE_PROVIDER
DATABASE_CONNECTION_URI
DATABASE_CONNECTION_CLIENT_NAME
CORS_ORIGIN
```

For Zeabur, expose HTTP port `8080` and mount a volume at:

```text
/evolution/instances
```

## Required Render Environment Variables

Set these in the new Render service only:

```text
SERVER_URL
AUTHENTICATION_API_KEY
CORS_ORIGIN
```

`DATABASE_CONNECTION_URI` is supplied by `render.yaml` from the new Render database.

## Quick Deployment Summary

1. Push this repository to GitHub.
2. In Render, create a new Blueprint from this repository.
3. Render creates `zappy-evolution` and `zappy-evolution-postgres`.
4. Set the required environment variables.
5. Deploy.
6. Verify:

   ```bash
   export EVOLUTION_API_URL=https://wa.zappy.rest
   export EVOLUTION_API_KEY=your-render-authentication-api-key
   export INSTANCE_NAME=zappy_verify
   ./scripts/verify-all.sh
   ```

## Local Docker Run

Docker is optional for local validation.

```bash
cp .env.example .env
```

Fill required values in `.env`, then:

```bash
docker compose up --build
```

Health check:

```bash
EVOLUTION_API_URL=http://localhost:8080 ./scripts/verify-health.sh
```

## Documentation

- [Zeabur Deployment Guide](ZEABUR_DEPLOYMENT.md)
- [Deployment Guide](docs/DEPLOYMENT.md)
- [Verification Checklist](docs/VERIFICATION.md)
- [Rollback Plan](docs/ROLLBACK.md)
- [Security Review](docs/SECURITY.md)

## Official References

- Evolution API Docker install docs: https://docs.evolution-api.com/v2/en/get-started/install/docker
- Evolution API upstream Docker Compose: https://github.com/evolution-foundation/evolution-api/blob/main/docker-compose.yaml
- Evolution API upstream environment example: https://github.com/evolution-foundation/evolution-api/blob/main/.env.example
