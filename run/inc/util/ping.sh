#!/usr/bin/env bash

#
# Install ping (`iputils-ping`).
#
# Not present in `debian:bookworm-slim`, which is the base image for my
# devcontainers, so there is no basic reachability check for diagnosing
# whether a container can reach a registry or API.
#
# https://github.com/iputils/iputils
#

print_step "Installing ping."

print_info "Installing/updating ping via APT."
superdo apt-get install -y iputils-ping

ping -V
