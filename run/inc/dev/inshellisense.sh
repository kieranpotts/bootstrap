#!/usr/bin/env bash

#
# Installs inshellisense - IDE-style autocomplete for the shell - and wires
# it into Bash startup so it launches automatically in new shell sessions.
#
# Requires Node.js >=18 <23.
#
# https://github.com/microsoft/inshellisense
#

print_step "Installing inshellisense."

# Install steps are run in non-interactive subshells.
# Need to re-source NVM, so npm is available in the subshell.
if [[ -s "${HOME}/.nvm/nvm.sh" ]]; then
  . "${HOME}/.nvm/nvm.sh"
fi

print_info "Installing/updating inshellisense globally via NPM."
npm install -g @microsoft/inshellisense

is --version

# Add to ~/.bashrc (or ~/local.bashrc) so inshellisense automatically opens in
# every new shell session.
print_info "Configuring ~/.bashrc to load inshellisense shell startup."

# The naive approach below - letting `is init bash` append its raw sourcing
# line unconditionally - was found to break tmux pane rendering. That's
# because both inshellisense and tmux wrap the shell in their own
# pseudo-terminal, and nesting the two causes redraw/cursor-position escape
# sequences to fight each other, corrupting pane output. Left here, commented
# out, for reference:

# shellcheck disable=SC2154
##if [[ -f "${bashrc}" ]]; then
##  if ! grep -qF ".inshellisense/init/bash/init.sh" "${bashrc}"; then
##    is init bash >> "${bashrc}"
##  fi
##fi

# Instead, guard the sourcing on `$TMUX` being unset, so inshellisense only
# initializes in a top-level terminal, never inside a tmux pane.
# shellcheck disable=SC2154
if [[ -f "${bashrc}" ]]; then
  if ! grep -qF ".inshellisense/init/bash/init.sh" "${bashrc}"; then
    {
      echo "if [[ -z \"\${TMUX}\" ]]; then"
      is init bash | sed 's/^/  /'
      echo "fi"
    } >> "${bashrc}"
  fi
fi
