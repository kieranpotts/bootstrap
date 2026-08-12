#!/usr/bin/env bash

#
# Install rsync.
#
# Not present in `debian:bookworm-slim`, which is the base image for my
# devcontainers, so there is no efficient way to sync files to or from
# another host - a tool scripts commonly assume is already on `PATH`.
#
# https://rsync.samba.org/
#

print_step "Installing rsync."

print_info "Installing/updating rsync via APT."
superdo apt-get install -y rsync

rsync --version
