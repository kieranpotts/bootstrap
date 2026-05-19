#!/bin/bash

#
# Install wget.
# wget is required for installation of other packages.
#

print_step "Install wget"
print_info "Installing/updating wget via APT."

superdo apt-get install -y wget

wget --version
