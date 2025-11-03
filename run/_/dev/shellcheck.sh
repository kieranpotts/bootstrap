#!/bin/bash

# ==============================================================================
# Install ShellCheck.
#
# https://github.com/koalaman/shellcheck
# ==============================================================================

startNewTask "Install shellcheck"

sudo apt-get install -y shellcheck
