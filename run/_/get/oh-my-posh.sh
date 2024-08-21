#!/bin/bash

# ==============================================================================
# Install Oh-My-Posh.
#
# https://ohmyposh.dev/docs/installation/linux
# ==============================================================================

startNewTask "Install Oh-My-Posh"

# By default, the oh-my-posh binary will be installed in /home/<user>/bin.
# This script will install it in /usr/local/bin instead - it's the same
# location as lazygit.
curl -s https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/local/bin
