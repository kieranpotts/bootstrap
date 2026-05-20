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

print_info "Installing/updating Claude Code globally via NPM."
npm install -g @anthropic-ai/claude-code
claude --version
