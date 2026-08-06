#!/usr/bin/env bash

#
# Install Neovim.
#
# https://github.com/neovim/neovim/blob/master/INSTALL.md
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing Neovim."

print_info "Installing/updating Neovim via APT."
superdo apt-get install -y neovim
nvim --version
