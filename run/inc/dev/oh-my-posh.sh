#!/usr/bin/env bash

#
# Install Oh-My-Posh.
#
# https://ohmyposh.dev/docs/installation/linux
#

print_step "Install Oh-My-Posh"

# By default, the oh-my-posh binary will be installed in /home/<user>/bin.
# This script will install it in /usr/local/bin instead - it's the same
# location as lazygit.
curl -s https://ohmyposh.dev/install.sh | superdo bash -s -- -d /usr/local/bin

oh-my-posh --version
