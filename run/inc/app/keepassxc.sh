#!/usr/bin/env bash

#
# Install KeePassXC.
#

is_gui_enabled || return 0

print_step "Installing KeePassXC."

print_info "Installing KeePassXC via APT."
superdo apt-get install -y keepassxc

print_success "KeePassXC installed successfully."
