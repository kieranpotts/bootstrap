#!/usr/bin/env bash

#
# Installs Firefox.
#
# Depends on `pkg/mozilla.sh` to add Mozilla's own package registry to APT.
#
# https://support.mozilla.org/en-US/kb/install-firefox-linux
#

print_step "Installing Firefox."

print_info "Installing/updating Firefox via APT."
superdo apt-get install -y firefox

print_info "Installing/updating Firefox Developer Edition, too."
superdo apt-get install -y firefox-devedition
