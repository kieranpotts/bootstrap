#!/usr/bin/env bash

#
# Install Vim (the `vim-tiny` build).
#
# A minimal editor. This is installed into the `cli` profile, rather than the
# `tui` profile, even though `cli` is intended to target headless (non-display)
# environments. The reason is it provides humans a convenient way to edit files,
# eg. `.gitconfig`, inside containers where the `cli` profile has been
# bootstrapped.
#
# Neovim remains the full-featured editor that's installed in the `tui` profile.
#
# https://packages.debian.org/bookworm/vim-tiny
#

print_step "Installing Vim."

print_info "Installing/updating Vim via APT."
superdo apt-get install -y vim-tiny

vim.tiny --version
