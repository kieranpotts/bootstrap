#!/bin/bash

# ==============================================================================
# Install git-secret, a bash-tool to store your private data inside a git repo.
#
# Requires GPG and git.
#
# https://github.com/sobolevn/git-secret
# ==============================================================================

startNewTask "Install git-secret"

superdo apt-get install -y git-secret

git secret --version
