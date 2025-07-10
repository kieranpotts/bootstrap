#!/bin/bash

# ==============================================================================
# Install `git-crypt`, ...
#
# https://github.com/tj/git-extras
# ==============================================================================

startNewTask "Install git-crypt"

sudo apt install git-crypt

git-crypt --version
