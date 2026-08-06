#!/usr/bin/env bash

#
# Install Docker Community Edition (CE).
#
# Docker CE includes the following components:
#
# - Docker Engine: the core containerization runtime.
# - Docker CLI: a command-line interface to the engine.
# - Docker Compose: for multi-container applications.
# - And basic container orchestration features.
#
# Depends on `pkg/docker.sh`. The official Docker package registry
# is expected to be prioritized as a package source.
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
# The group/service setup is one-time, can be skipped on `./run/update`.
is_updating && return 0

print_step "Installing Docker Community Edition."

print_info "Installing/updating Docker CE via APT."
superdo apt-get install -y docker-ce

# By default, the `docker` command can be run only by the root user, or by a
# user in the `docker` group (which is automatically created during Docker’s
# installation process). Add the current user to the `docker` group so that
# they can run Docker commands without `sudo`. This change will take effect
# the next time the user logs in.

# Resolve the current user via `id -un` rather than ${USER}: the latter is not
# set in non-interactive contexts like a `docker build` RUN layer (even after a
# `USER` instruction), which would abort under `set -u`.
print_info "Adding current user to 'docker' group."
superdo usermod -aG docker "$(id -un)"

# Enabling and starting the engine requires systemd as the init system. In
# environments without it — such as inside a container / `docker build` layer
# (which reports "System has not been booted with systemd as init system") — skip
# this. There the daemon is managed by the host or container runtime instead.
if [[ -d /run/systemd/system ]]; then
  # Register the Docker Engine to start automatically on subsequent boots, so
  # it is available in the background for tools like VS Code devcontainers
  # without needing to be started manually each session.
  print_info "Enabling the docker engine to start automatically."
  superdo systemctl enable docker

  # Start the Docker daemon immediately so it is available in the current session
  # for tools installed later in the bootstrap process.
  print_info "Starting the docker engine now."
  superdo systemctl start docker
else
  print_info "systemd not available (eg. inside a container). Skipping docker engine enable/start."
fi
