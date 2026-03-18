#!/bin/bash

# ==============================================================================
# Install `git-crypt`, ...
#
# https://github.com/tj/git-extras
# ==============================================================================

startNewTask "Install git-crypt"

superdo apt install git-crypt

git-crypt --version
