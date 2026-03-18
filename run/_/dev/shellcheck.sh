#!/bin/bash

# ==============================================================================
# Install ShellCheck.
#
# https://github.com/koalaman/shellcheck
# ==============================================================================

startNewTask "Install shellcheck"

superdo apt-get install -y shellcheck
