#!/usr/bin/env bash

#
# Install icoutils.
#
# icoutils provides icotool, which is used to extract images from .ico files.
#

print_step "Installing icoutils."

print_info "Installing/updating icoutils via APT."
superdo apt-get install -y icoutils
