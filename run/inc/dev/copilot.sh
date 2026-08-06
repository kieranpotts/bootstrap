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

print_step "Installing Copilot CLI."

# Install steps are run in non-interactive subshells.
# Need to re-source NVM, so npm is available in the subshell.
if [[ -s "${HOME}/.nvm/nvm.sh" ]]; then
  . "${HOME}/.nvm/nvm.sh"
fi

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! command -v copilot >/dev/null 2>&1; then
  return 0
fi

print_info "Installing/updating GitHub Copilot CLI globally via NPM."
npm install -g @github/copilot
copilot --version
