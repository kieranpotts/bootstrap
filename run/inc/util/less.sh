#!/usr/bin/env bash

#
# Install less.
#
# A pager for viewing file and command output a screen at a time. Not
# present in the `debian:bookworm-slim` base image, and several other
# tools (eg. `git log`, `man`) shell out to it by default.
#
# https://www.greenwoodsoftware.com/less/
#

print_step "Installing less."

print_info "Installing/updating less via APT."
superdo apt-get install -y less

less --version
