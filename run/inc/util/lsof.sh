#!/usr/bin/env bash

#
# Install lsof.
#
# Lists open files, including the process holding a given TCP/UDP port.
#
# Not present in `debian:bookworm-slim`, which is the base image for my
# devcontainers, so there is no way to answer "what has this file or port
# open" - eg. diagnosing why a dev server fails to bind with `EADDRINUSE`.
#
# https://github.com/lsof-org/lsof
#

print_step "Installing lsof."

print_info "Installing/updating lsof via APT."
superdo apt-get install -y lsof
