#!/usr/bin/env bash

#
# Install htop.
#

print_step "Installing htop."

print_info "Installing/updating htop via APT."
superdo apt-get install -y htop
