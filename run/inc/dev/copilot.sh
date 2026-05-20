#!/usr/bin/env bash

#
# Installs GitHub Copilot CLI.
#
# Requires Node.js v22, NPM v10.
#
# https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli
# https://docs.github.com/en/copilot
# https://github.com/orgs/community/discussions/categories/copilot-conversations
#

print_step "Install Copilot CLI."

print_info "Installing/updating GitHub Copilot CLI globally via NPM."
print_info "Global Node modules are owned by root, so explicitly installing as root (sudo)."
sudo npm install -g @github/copilot
copilot --version
