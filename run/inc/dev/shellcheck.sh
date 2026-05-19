#!/usr/bin/env bash

#
# Install ShellCheck.
#
# https://github.com/koalaman/shellcheck
#

print_step "Installing ShellCheck."

print_info "Installing/updating ShellCheck via APT."
superdo apt-get install -y shellcheck
shellcheck --version
