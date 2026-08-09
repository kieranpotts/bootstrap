#!/usr/bin/env bash

#
# Install Zed editor.
#
# https://zed.dev/docs/installation
#

print_step "Installing Zed."

print_info "Installing/updating Zed via official install.sh script."
curl -f https://zed.dev/install.sh | sh
