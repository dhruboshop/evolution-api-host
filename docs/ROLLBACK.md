# Rollback Plan

This service is independent from LoyaltyPilot.

Rollback does not affect:

- LoyaltyPilot GitHub repository.
- LoyaltyPilot Render backend.
- LoyaltyPilot Vercel frontend.
- LoyaltyPilot Supabase project.

## If First Deployment Fails

1. Open the new Render service:

   ```text
   evolution-api-host
   ```

2. Click Manual Deploy.
3. Choose a previous successful deploy if one exists.
4. If no successful deploy exists, suspend or delete only this new service.

## If The Docker Image Fails

1. Edit the Docker build argument in Render or Dockerfile:

   ```text
   EVOLUTION_API_IMAGE=evoapicloud/evolution-api:v2.3.6
   ```

2. Pin the last known working image tag.
3. Redeploy only `evolution-api-host`.

## If Database Migration Or Startup Fails

1. Do not touch LoyaltyPilot Supabase.
2. Open the Render database created for this service:

   ```text
   evolution-api-postgres
   ```

3. Restore from Render backup if available.
4. If this is a new test deployment, delete and recreate only the Evolution database.

## If API Key Is Exposed

1. Generate a new `AUTHENTICATION_API_KEY`.
2. Update the Render environment variable.
3. Redeploy the Evolution API service.
4. Delete any unknown Evolution instances.

## Emergency Isolation

To fully isolate the service:

1. Suspend `evolution-api-host` in Render.
2. Rotate `AUTHENTICATION_API_KEY`.
3. Keep LoyaltyPilot unchanged.

