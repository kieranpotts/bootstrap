#!/bin/bash

#
# Install Neovim.
#
# https://github.com/neovim/neovim/blob/master/INSTALL.md
#

startNewTask "Install Neovim"

superdo apt-get install -y neovim

nvim --version
