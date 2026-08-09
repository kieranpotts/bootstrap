#!/usr/bin/env bash

#
# Install Oh-My-Posh.
#
# https://ohmyposh.dev/docs/installation/linux
#

print_step "Installing Oh-My-Posh."

# By default, the oh-my-posh binary will be installed in /home/<user>/bin.
# This script will install it in /usr/local/bin instead - it's the same
# location as lazygit.

curl -s https://ohmyposh.dev/install.sh | superdo bash -s -- -d /usr/local/bin

# Enable automatic upgrades. This is a per-user setting (creates a cron/
# systemd timer entry for the invoking user), so it must NOT run under
# `superdo` — otherwise the autoupgrade job would be installed for root
# instead of the actual user on local installs.
oh-my-posh enable upgrade

oh-my-posh --version
