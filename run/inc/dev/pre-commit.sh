#!/usr/bin/env bash

#
# Install pre-commit framework.
#
# https://pre-commit.com
#

print_step "Installing pre-commit."

# pipx installs into ~/.local/bin, which is added to .bashrc by python.sh, but
# it may not yet be in the current bootstrap shell's PATH. Export it now, so
# it's ready for both the presence check below and the version check at the
# end.
export PATH="${HOME}/.local/bin:${PATH}"

print_info "Installing/updating pre-commit via pipx."
pipx install pre-commit

pre-commit --version
