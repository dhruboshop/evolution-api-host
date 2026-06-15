# Rollback Plan

This service is isolated. Rollback does not affect:

- LoyaltyPilot GitHub repository.
- LoyaltyPilot Render backend.
- LoyaltyPilot Vercel frontend.
- LoyaltyPilot Supabase project.

## Roll Back A Failed Deploy

1. Open Render.
2. Open `loyaltypilot-evolution`.
3. Open Events or Deploys.
4. Select the last successful deploy.
5. Click Rollback or Manual Deploy for that version.

## Suspend The Service

If there is no successful deploy:

1. Open `loyaltypilot-evolution`.
2. Click Suspend Service.
3. Leave LoyaltyPilot untouched.

## Delete And Recreate Only Evolution

For a broken first-time deployment:

1. Delete `loyaltypilot-evolution`.
2. Delete `loyaltypilot-evolution-postgres`.
3. Recreate the Blueprint from this repository.

No LoyaltyPilot data is stored in this Evolution Postgres database until a future integration phase.

## Rotate A Leaked API Key

1. Generate a new long random `AUTHENTICATION_API_KEY`.
2. Update Render environment variables.
3. Redeploy `loyaltypilot-evolution`.
4. Delete unknown instances.

## Roll Back Docker Image Version

The default image follows:

```text
evoapicloud/evolution-api:latest
```

If a future `latest` image breaks production, pin the Docker build argument to the last known working version in Render or in `Dockerfile`, then redeploy only this repository.

