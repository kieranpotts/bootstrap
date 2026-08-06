#!/usr/bin/env bash

#
# Install Ghostty via APT from community Ubuntu repository.
#
# https://ghostty.org/docs/install/binary#linux
# https://github.com/mkasberg/ghostty-ubuntu
#

is_gui_enabled || return 0

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing Ghostty."

print_info "Installing/updating Ghostty via APT."
superdo apt-get install -y ghostty
