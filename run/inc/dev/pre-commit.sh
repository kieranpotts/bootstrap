#!/usr/bin/env bash

#
# Install pre-commit framework.
#
# https://pre-commit.com
#

print_step "Install pre-commit."

print_info "Installing/updating pre-commit via pipx."
pipx install pre-commit

# Ensure the pipx-installed binary is on PATH, ready for the version check.
# pipx installs into ~/.local/bin, which is added to .bashrc by python.sh, but
# it may not yet be in the current bootstrap shell's PATH.

export PATH="$HOME/.local/bin:$PATH"
pre-commit --version
