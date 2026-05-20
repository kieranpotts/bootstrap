#!/usr/bin/env bash

#
# Installs Microsoft Edge browser - stable channel.
#
# Depends on Microsoft package sources - configured via `pkg/microsoft.sh`.
#

is_gui_enabled || return 0

print_step "Installing Microsoft Edge."

print_info "Installing Microsoft Edge (stable channel) via APT."
sudo apt-get install -y microsoft-edge-stable
