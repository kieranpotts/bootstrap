#!/usr/bin/env bash

#
# Install VS Codium – a fully free/libre version of Visual Studio Code.
#
# https://github.com/VSCodium/vscodium/
#

is_gui_enabled || return 0

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing VS Codium."

print_info "Installing/updating VS Codium via APT."
superdo apt-get install -y codium
