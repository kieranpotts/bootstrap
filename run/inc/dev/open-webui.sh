#!/usr/bin/env bash

#
# Installs Open WebUI, a self-hosted web interface for interacting with local
# LLMs. Run as a Docker container, wired to the host's Ollama service.
#
# https://github.com/open-webui/open-webui
#
# Depends on `exec/docker.sh` (Docker engine) and pairs with `dev/ollama.sh`
# (the LLM backend, reachable from the container via host.docker.internal).
#

print_step "Installing Open WebUI."

# Open WebUI runs as a long-lived container, which requires a running Docker
# daemon. Inside a container / `docker build` layer there is no daemon (the
# user was only just added to the `docker` group, and it has no init system),
# so skip rather than fail. `superdo` is used for every docker command because
# the new `docker` group membership does not take effect until the next login.
if ! superdo docker info >/dev/null 2>&1; then
  print_info "Docker daemon not available (eg. inside a container). Skipping Open WebUI."
  return 0
fi

image="ghcr.io/open-webui/open-webui:main"
container="open-webui"

print_info "Pulling the latest Open WebUI image (${image})."
superdo docker pull "${image}"

# Recreate the container on every run so it picks up the freshly pulled image.
# The named volume `open-webui` persists user data (accounts, chats, settings)
# across recreations, so this is non-destructive.
if superdo docker ps -a --format '{{.Names}}' | grep -qx "${container}"; then
  print_info "Removing existing '${container}' container to recreate it from the new image."
  superdo docker rm -f "${container}"
fi

# --add-host wires the container to the host's Ollama service on
# host.docker.internal. --restart always brings it back up on boot and after
# crashes. The UI is served on http://localhost:3000.
print_info "Starting the '${container}' container on port 3000."
superdo docker run -d \
  -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name "${container}" \
  --restart always \
  "${image}"

print_success "Open WebUI is running at http://localhost:3000"
