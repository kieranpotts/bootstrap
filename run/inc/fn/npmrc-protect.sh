#!/usr/bin/env bash

#
# Protect ~/.npmrc from settings that are incompatible with NVM.
#
# NVM refuses to load at all if ~/.npmrc has a `prefix` or `globalconfig`
# setting - both conflict with NVM's per-version global directories. Some
# third-party npm-based installers write one of these directly into
# ~/.npmrc, typically via `npm config set prefix ...`, the classic "install
# npm packages without sudo" workaround. That workaround is unnecessary once
# NVM is installed, and if it recurs it silently breaks every step that
# sources `nvm.sh` - not just the step that installs NVM, but every later
# one too (rust.sh, pi.sh, etc.).
#
# Unlike `bashrc-protect.sh`, this doesn't need a snapshot/restore pair:
# `prefix`/`globalconfig` are never valid here while NVM is in use, so the
# fix is just to strip them, unconditionally, on every run.
#

# npmrc_protect - Remove any `prefix`/`globalconfig` line from ~/.npmrc.
#
# Called once, early in `run/install`/`run/update`, before any step that
# might source `nvm.sh`.
#
npmrc_protect() {
  if [[ ! -f "${HOME}/.npmrc" ]]; then
    return 0
  fi

  if ! grep -qE '^(prefix|globalconfig) *=' "${HOME}/.npmrc"; then
    return 0
  fi

  # Tilde "~" not intended to be expanded to $HOME.
  # shellcheck disable=SC2088
  print_warning "~/.npmrc has a prefix/globalconfig setting incompatible with NVM. Removing it."
  sed -i -E '/^(prefix|globalconfig) *=/d' "${HOME}/.npmrc"
}
