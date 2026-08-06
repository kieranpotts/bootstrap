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

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! command -v is >/dev/null 2>&1; then
  return 0
fi

print_info "Installing/updating inshellisense globally via NPM."
npm install -g @microsoft/inshellisense

is --version

# Add to ~/.bashrc (or ~/local.bashrc, if that's what `${bashrc}` resolves
# to - see `run/install`) so inshellisense automatically opens in every new
# shell session. Avoid duplication by checking for the presence of the
# sourcing line `is init bash` writes.
print_info "Configuring ~/.bashrc to load inshellisense shell startup."

# shellcheck disable=SC2154
if [[ -f "${bashrc}" ]]; then
  if ! grep -qF ".inshellisense/init/bash/init.sh" "${bashrc}"; then
    is init bash >> "${bashrc}"
  fi
fi
