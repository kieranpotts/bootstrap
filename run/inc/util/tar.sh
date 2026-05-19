#!/usr/bin/env bash

#
# Install tar.
#

print_step "Installing tar."

print_info "Installing/updating tar via APT."
superdo apt-get install -y tar
