#!/usr/bin/env bash

#
# Install bzip2.
#
# Not present in `debian:bookworm-slim`, which is the base image for my
# devcontainers, so there is no way to unpack a `.tar.bz2`/`.bz2` archive -
# a format some upstream releases still ship in, alongside `.tar.gz` and
# `.zip` (already covered by `gzip` and `unzip`).
#
# https://sourceware.org/bzip2/
#

print_step "Installing bzip2."

print_info "Installing/updating bzip2 via APT."
superdo apt-get install -y bzip2

bzip2 --version
