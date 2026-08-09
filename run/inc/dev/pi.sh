#!/usr/bin/env bash

#
# Install Pi Coding Agent.
#
# Requires Node.js and NPM.
#
# https://pi.dev
#

print_step "Installing Pi Coding Agent."

# Install steps are run in non-interactive subshells.
# Need to re-source NVM, so npm is available in the subshell.
if [[ -s "${HOME}/.nvm/nvm.sh" ]]; then
  . "${HOME}/.nvm/nvm.sh"
fi

print_info "Installing/updating Pi Coding Agent globally via NPM."
npm install -g @earendil-works/pi-coding-agent
