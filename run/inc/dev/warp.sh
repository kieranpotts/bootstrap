#!/usr/bin/env bash

#
# Install Warp.
#
# https://www.warp.dev/
#

is_gui_enabled || return 0

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing Warp."

print_info "Installing/updating Warp via APT."
superdo apt-get install -y warp-terminal

print_success "Warp installed successfully."
