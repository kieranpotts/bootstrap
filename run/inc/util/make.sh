#!/usr/bin/env bash

#
# Install GNU Make.
#

print_step "Installing GNU Make."

print_info "Installing/updating GNU Make via APT."
superdo apt-get install -y make

make --version
