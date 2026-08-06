#!/usr/bin/env bash

#
# Installs Microsoft Edge browser - stable channel.
#
# Depends on Microsoft package sources - configured via `pkg/microsoft.sh`.
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing Microsoft Edge."

print_info "Installing Microsoft Edge (stable channel) via APT."
superdo apt-get install -y microsoft-edge-stable
