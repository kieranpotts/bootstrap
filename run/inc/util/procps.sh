#!/usr/bin/env bash

#
# Install procps.
#
# Provides `ps`, `top`, `free`, `uptime`, `watch`, `pkill`, and `pgrep`. Not
# present in `debian:bookworm-slim`, which is the base image for my
# devcontainers, so there is no way to list or signal-by-name a background
# process (eg. a dev server an agent started) - `kill` only works if the PID
# is already known.
#
# https://gitlab.com/procps-ng/procps
#

print_step "Installing procps."

print_info "Installing/updating procps via APT."
superdo apt-get install -y procps

ps --version
