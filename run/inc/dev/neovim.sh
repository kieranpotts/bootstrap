#!/usr/bin/env bash

#
# Install Neovim.
#
# https://github.com/neovim/neovim/blob/master/INSTALL.md
#

print_step "Installing Neovim."

print_info "Installing/updating Neovim via APT."
superdo apt-get install -y neovim
nvim --version
