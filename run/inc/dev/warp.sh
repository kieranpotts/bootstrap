#!/usr/bin/env bash

#
# Install Warp.
#
# https://www.warp.dev/
#

print_step "Installing Warp."

print_info "Installing/updating Warp via APT."
superdo apt-get install -y warp-terminal

print_success "Warp installed successfully."
