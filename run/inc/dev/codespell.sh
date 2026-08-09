#!/usr/bin/env bash

#
# Install codespell.
#
# https://github.com/codespell-project/codespell
#

print_step "Installing codespell."

# pipx installs into ~/.local/bin, which is added to .bashrc by python.sh, but
# it may not yet be in the current bootstrap shell's PATH. Export it now, so
# it's ready for both the presence check below and the version check at the
# end.
export PATH="${HOME}/.local/bin:${PATH}"

print_info "Installing/updating codespell via pipx."
pipx install codespell

codespell --version
