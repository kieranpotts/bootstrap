#!/usr/bin/env bash

#
# Install iproute2.
#
# Provides `ip` (and `ss`, `tc`), the modern replacement for the
# `net-tools` suite (`ifconfig`, `netstat`, `route`).
#
# Not present in `debian:bookworm-slim`, which is the base image for my
# devcontainers, so there is no way to inspect a container's network
# interfaces or routes when diagnosing connectivity.
#
# https://wiki.linuxfoundation.org/networking/iproute2
#

print_step "Installing iproute2."

print_info "Installing/updating iproute2 via APT."
superdo apt-get install -y iproute2

ip -V
