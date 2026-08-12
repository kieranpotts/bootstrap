#!/usr/bin/env bash

#
# Install XZ Utils.
#
# Provides `xz`, `unxz`, and `xzcat`.
#
# Not present in `debian:bookworm-slim`, which is the base image for my
# devcontainers, so there is no way to unpack a `.tar.xz`/`.xz` archive -
# a format most upstream release tarballs ship in.
#
# https://tukaani.org/xz/
#

print_step "Installing XZ Utils."

print_info "Installing/updating XZ Utils via APT."
superdo apt-get install -y xz-utils

xz --version
