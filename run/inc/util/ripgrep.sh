#!/usr/bin/env bash

#
# Install ripgrep (`rg`).
#
# ripgrep is a line-oriented search tool that recursively searches the current
# directory for a regex pattern. By default, ripgrep will respect gitignore
# rules and automatically skip hidden files/directories and binary files.
#
# https://github.com/burntsushi/ripgrep
#

print_step "Installing ripgrep."

print_info "Installing/updating ripgrep via APT."
superdo apt-get install -y ripgrep

rg --version

