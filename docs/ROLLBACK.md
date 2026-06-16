# Rollback Plan

This service is isolated. Rollback does not affect:

- Zappy GitHub repository.
- Zappy Render backend.
- Zappy Vercel frontend.
- Zappy Supabase project.

## Roll Back A Failed Deploy

1. Open Render.
2. Open `zappy-evolution`.
3. Open Events or Deploys.
4. Select the last successful deploy.
5. Click Rollback or Manual Deploy for that version.

## Suspend The Service

If there is no successful deploy:

1. Open `zappy-evolution`.
2. Click Suspend Service.
3. Leave Zappy untouched.

## Delete And Recreate Only Evolution

For a broken first-time deployment:

1. Delete `zappy-evolution`.
2. Delete `zappy-evolution-postgres`.
3. Recreate the Blueprint from this repository.

No Zappy data is stored in this Evolution Postgres database until a future integration phase.

## Rotate A Leaked API Key

1. Generate a new long random `AUTHENTICATION_API_KEY`.
2. Update Render environment variables.
3. Redeploy `zappy-evolution`.
4. Delete unknown instances.

## Roll Back Docker Image Version

The default image follows:

```text
evoapicloud/evolution-api:latest
```

If a future `latest` image breaks production, pin the Docker build argument to the last known working version in Render or in `Dockerfile`, then redeploy only this repository.

