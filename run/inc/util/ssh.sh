#!/usr/bin/env bash

#
# Install the OpenSSH client (`openssh-client`).
#
# Provides `ssh`, `scp`, and `sftp`.
#
# Not present in `debian:bookworm-slim`, which is the base image for my
# devcontainers, so there is no way to reach a `git@`-style SSH remote or
# copy a file to/from another host, even though `git`, `gh`, and `git-lfs`
# are already installed unattended.
#
# https://www.openssh.com/
#

print_step "Installing the OpenSSH client."

print_info "Installing/updating the OpenSSH client via APT."
superdo apt-get install -y openssh-client

ssh -V
