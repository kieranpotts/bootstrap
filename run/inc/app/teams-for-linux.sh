#!/usr/bin/env bash

#
# Install Teams for Linux.
#
# It's a native desktop app that wraps the Teams web version with enhanced
# Linux integration.
#
# Depends on the package registry being configured via
# `pkg/teams-for-linux.sh`.
#
# https://ismaelmartinez.github.io/teams-for-linux/installation/
#

print_step "Installing Teams for Linux."

print_info "Installing/updating Teams for Linux via APT."
superdo apt-get install -y teams-for-linux

teams-for-linux --version
