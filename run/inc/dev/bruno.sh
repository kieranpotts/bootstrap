#!/usr/bin/env bash

#
# Install Bruno.
#
# https://www.usebruno.com/
#

is_gui_enabled || return 0

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing Bruno."

print_info "Installing/updating Bruno via APT."
superdo apt-get install -y bruno
