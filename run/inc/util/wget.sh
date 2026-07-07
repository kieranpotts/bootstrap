#!/usr/bin/env bash

#
# Install wget.
#
# wget is required for installation of some packages.
#

print_step "Installing wget."

print_info "Installing/updating wget via APT."
superdo apt-get install -y wget

wget --version
