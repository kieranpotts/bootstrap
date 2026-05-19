#!/usr/bin/env bash

#
# Installs GitHub Copilot CLI.
#
# https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli
# https://docs.github.com/en/copilot
# https://github.com/orgs/community/discussions/categories/copilot-conversations
#
# Requires Node.js v22, NPM v10.
#

print_step "Install Copilot CLI."

print_info "Installing GitHub Copilot CLI globally via NPM."
npm install -g @github/copilot
copilot --version
