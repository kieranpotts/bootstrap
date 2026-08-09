#!/usr/bin/env bash

#
# Install Bruno.
#
# https://www.usebruno.com/
#

print_step "Installing Bruno."

print_info "Installing/updating Bruno via APT."
superdo apt-get install -y bruno
