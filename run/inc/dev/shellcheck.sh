#!/usr/bin/env bash

#
# Install ShellCheck.
#
# https://github.com/koalaman/shellcheck
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing ShellCheck."

print_info "Installing/updating ShellCheck via APT."
superdo apt-get install -y shellcheck
shellcheck --version
