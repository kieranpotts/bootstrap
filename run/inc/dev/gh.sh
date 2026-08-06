#!/usr/bin/env bash

#
# Install the GitHub CLI (`gh`).
#
# Depends on `pkg/github.sh` to set up package source in APT.
#
# https://github.com/cli/cli
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing GitHub CLI."

# Install the GitHub CLI.
superdo apt-get update
superdo apt-get install -y gh
gh --version
