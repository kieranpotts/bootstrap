#!/usr/bin/env bash

#
# Install `pass`, a widely-used password manager for Unix systems.
# Required to authenticate with Docker Desktop.
#
# https://www.passwordstore.org/
#

is_gui_enabled || return 0

print_step "Installing pass."

print_info "Installing pass via APT."
superdo apt-get install -y pass
