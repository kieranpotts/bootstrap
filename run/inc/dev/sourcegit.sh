#!/usr/bin/env bash

#
# Install SourceGit, an OpenSource Git GUI client.
#
# Depends on package registry being configured via `pkg/sourcegit.sh`.
#
# https://sourcegit-scm.github.io/
# https://github.com/sourcegit-scm/sourcegit
#

is_gui_enabled || return 0

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing SourceGit."

print_info "Installing/updating sourcegit via APT."
superdo apt-get install -y sourcegit
