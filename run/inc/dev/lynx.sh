#!/usr/bin/env bash

#
# Installs Lynx - a text-only web browser for the terminal.
#
# https://lynx.invisible-island.net/
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing Lynx."

print_info "Installing/updating Lynx via APT."
superdo apt-get install -y lynx

lynx --version
