#!/bin/bash

#
# Install Neovim.
#
# https://github.com/neovim/neovim/blob/master/INSTALL.md
#

print_step "Install Neovim"

superdo apt-get install -y neovim

nvim --version
