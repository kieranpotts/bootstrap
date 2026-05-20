#!/usr/bin/env bash

#
# Install lsb-release.
#
# The `lsb-release` package provides Linux Standard Base (LSB) information about
# the current distribution. The `lsb_release` command is often used in scripts
# to determine the version of the operating system.
#

print_step "Installing lsb-release."

print_info "Installing/updating lsb-release via APT."
superdo apt-get install -y lsb-release
