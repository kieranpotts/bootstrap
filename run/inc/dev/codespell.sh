#!/usr/bin/env bash

#
# Install codespell.
#
# https://github.com/codespell-project/codespell
#

print_step "Install codespell."

print_info "Installing/updating codespell via pipx."
pipx install codespell

# Ensure the pipx-installed binary is on PATH, ready for the version check.
# pipx installs into ~/.local/bin, which is added to .bashrc by python.sh, but
# it may not yet be in the current bootstrap shell's PATH.

export PATH="${HOME}/.local/bin:${PATH}"
codespell --version
