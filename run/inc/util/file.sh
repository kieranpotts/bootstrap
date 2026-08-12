#!/usr/bin/env bash

#
# Install file.
#
# Identifies a file's type by inspecting its content, rather than trusting
# its name or extension.
#
# Not present in `debian:bookworm-slim`, which is the base image for my
# devcontainers, so there is no way to answer "what kind of file is this" -
# a check scripts and linters commonly shell out to by default.
#
# https://darwinsys.com/file/
#

print_step "Installing file."

print_info "Installing/updating file via APT."
superdo apt-get install -y file
