#!/usr/bin/env bash

#
# Installs Firefox.
#
# Requires Mozilla's official package repository to be added to APT.
# https://support.mozilla.org/en-US/kb/install-firefox-linux
#

is_gui_enabled || return 0

print_step "Installing Firefox."

print_info "Installing/updating Firefox via APT."
superdo apt-get install -y firefox

print_info "Installing/updating Firefox Developer Edition, too."
superdo apt-get install -y firefox-devedition
