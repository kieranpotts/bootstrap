#!/usr/bin/env bash

#
# Installs Cline Kanban for agentic workflows.
#
# https://cline.bot/kanban
#

print_step "Installing Cline Kanban."

# Install steps are run in non-interactive subshells.
# Need to re-source NVM, so npm is available in the subshell.
if [[ -s "${HOME}/.nvm/nvm.sh" ]]; then
  . "${HOME}/.nvm/nvm.sh"
fi

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! command -v cline >/dev/null 2>&1; then
  return 0
fi

print_info "Installing/updating Cline globally via NPM."
npm install -g cline
