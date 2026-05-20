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

# Install steps are run in non-interactive subshells.
# Need to re-source NVM, so npm is available in the subshell.
if [[ -s "${HOME}/.nvm/nvm.sh" ]]; then
  . "${HOME}/.nvm/nvm.sh"
fi

print_info "Installing/updating GitHub Copilot CLI globally via NPM."
npm install -g @github/copilot
copilot --version
