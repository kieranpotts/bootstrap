#!/usr/bin/env bash

#
# Install VS Codium – a fully free/libre version of Visual Studio Code.
#
# https://github.com/VSCodium/vscodium/
#

print_step "Installing VS Codium."

print_info "Installing/updating VS Codium via APT."
superdo apt-get install -y codium
