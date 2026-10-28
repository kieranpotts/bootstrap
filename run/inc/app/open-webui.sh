#!/usr/bin/env bash

#
# Installs Open WebUI, a self-hosted web interface for interacting with local
# LLMs. Run as a Docker container, wired to the host's Ollama service. The
# container is created but not started, so it only runs when started on demand.
#
# https://github.com/open-webui/open-webui
#
# Depends on `exec/docker.sh` (Docker engine) and pairs with `dev/ollama.sh`
# (the LLM backend, reachable from the container via host.docker.internal).
#
# Categorized as a GUI app, not a dev tool: it's a browser-based end-user
# interface, not something scripts or agents drive directly.
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

# The container is created but deliberately not started, and has no restart
# policy, so Open WebUI does not run by default. It is resource-hungry and hogs
# port 3000, which often conflicts with development servers.
#
# Start it on manually with `docker start open-webui` and stop it with
# `docker stop open-webui`.
#
# `--add-host` wires the container to the host's Ollama service on
# host.docker.internal. When started, the UI is served on
# http://localhost:3000.
print_info "Creating the '${container}' container (not started) on port 3000."
superdo docker create \
  -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name "${container}" \
  --restart no \
  "${image}"

print_success "Open WebUI is installed but not running. Start it with: docker start ${container}"
