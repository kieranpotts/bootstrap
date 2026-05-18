#!/bin/bash

#
# Install pre-commit framework.
#
# https://pre-commit.com
#

startNewTask "Install pre-commit"

pipx install pre-commit

# Ensure the pipx-installed binary is on PATH for the version check below.
# pipx installs into ~/.local/bin, which is added to .bashrc by python.sh but
# may not yet be in the current bootstrap shell's PATH.
export PATH="$HOME/.local/bin:$PATH"

pre-commit --version
