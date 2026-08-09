#!/usr/bin/env bash

#
# Install KeePassXC.
#
# Depends on the package registry being configured
# via `pkg/keeypassxc.sh`.
#

print_step "Installing KeePassXC."

print_info "Installing/updating KeePassXC via APT."
superdo apt-get install -y keepassxc
