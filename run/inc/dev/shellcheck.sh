#!/bin/bash

#
# Install ShellCheck.
#
# https://github.com/koalaman/shellcheck
#

print_step "Install shellcheck"

superdo apt-get install -y shellcheck

shellcheck --version
