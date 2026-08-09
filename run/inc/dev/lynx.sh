#!/usr/bin/env bash

#
# Installs Lynx - a text-only web browser for the terminal.
#
# https://lynx.invisible-island.net/
#

print_step "Installing Lynx."

print_info "Installing/updating Lynx via APT."
superdo apt-get install -y lynx

lynx --version
