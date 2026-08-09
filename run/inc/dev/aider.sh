#!/usr/bin/env bash

#
# Install Aider.
#
# https://aider.chat/docs/install.html
#

print_step "Installing Aider."

print_info "Installing aider installer in pipx."
python3 -m pipx install aider-install

print_info "Running aider installer."
aider-install
