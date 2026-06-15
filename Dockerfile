ARG EVOLUTION_API_IMAGE=evoapicloud/evolution-api:latest

FROM ${EVOLUTION_API_IMAGE}

LABEL org.opencontainers.image.title="LoyaltyPilot Evolution API Host"
LABEL org.opencontainers.image.description="Independent Evolution API deployment wrapper for Zeabur and Render"

COPY scripts/evolution-diagnostics.mjs /usr/local/bin/evolution-diagnostics.mjs
ENV NODE_OPTIONS="--import /usr/local/bin/evolution-diagnostics.mjs"

EXPOSE 8080
