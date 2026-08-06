#!/usr/bin/env bash

#
# Install KeePassXC.
#
# Depends on the package registry being configured
# via `pkg/keeypassxc.sh`.
#

is_gui_enabled || return 0

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing KeePassXC."

print_info "Installing/updating KeePassXC via APT."
superdo apt-get install -y keepassxc
