ARG EVOLUTION_API_IMAGE=evoapicloud/evolution-api:v2.3.6

FROM ${EVOLUTION_API_IMAGE}

LABEL org.opencontainers.image.title="LoyaltyPilot Evolution API Host"
LABEL org.opencontainers.image.description="Independent Evolution API deployment wrapper for Render"

EXPOSE 8080

