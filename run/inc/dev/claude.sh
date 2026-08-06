#!/usr/bin/env bash

#
# Installs Claude Code.
#
# Requires Node.js v18 or newer.
#
# https://docs.anthropic.com/en/docs/claude-code/overview
#

print_step "Installing Claude Code."

# Install steps are run in non-interactive subshells.
# Need to re-source NVM, so npm is available in the subshell.
if [[ -s "${HOME}/.nvm/nvm.sh" ]]; then
  . "${HOME}/.nvm/nvm.sh"
fi

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! command -v claude >/dev/null 2>&1; then
  return 0
fi

print_info "Installing/updating Claude Code globally via NPM."
npm install -g @anthropic-ai/claude-code

claude --version
