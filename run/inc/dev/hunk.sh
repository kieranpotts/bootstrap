#!/usr/bin/env bash

#
# Install Hunk, a review-first terminal diff viewer for agent-authored
# changesets.
#
# Requires Node.js (22+) and NPM.
#
# https://github.com/modem-dev/hunk
# https://hunk.dev/
#

print_step "Installing Hunk."

# Install steps are run in non-interactive subshells.
# Need to re-source NVM, so npm is available in the subshell.
if [[ -s "${HOME}/.nvm/nvm.sh" ]]; then
  . "${HOME}/.nvm/nvm.sh"
fi

print_info "Installing/updating Hunk globally via NPM."
npm install -g hunkdiff

hunk --version
