#!/usr/bin/env bash

#
# Install inotify-tools.
#
# We use this utility to setup file watchers, eg. for automatic rebuilds,
# in the host system.
#

print_step "Installing inotify-tools."

print_info "Installing/updating inotify-tools via APT."
superdo apt-get install -y inotify-tools
