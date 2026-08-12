#!/usr/bin/env bash

#
# Install DNS lookup utilities (`bind9-dnsutils`).
#
# Provides `dig`, `host`, and `nslookup`.
#
# Not present in `debian:bookworm-slim`, which is the base image for my
# devcontainers, so there is no way to resolve a hostname when diagnosing
# whether a container can reach a registry or API.
#
# https://packages.debian.org/bookworm/bind9-dnsutils
#

print_step "Installing DNS lookup utilities."

print_info "Installing/updating DNS lookup utilities via APT."
superdo apt-get install -y bind9-dnsutils

dig -v
