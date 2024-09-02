#!/bin/bash

# ==============================================================================
# Install `git-extras`, a popular package that extends git with additional
# commands. This will add a whole bunch of `git-*` files to the `/usr/bin`
# directory, which Git will automatically make available as `git` subcommands
# (aliases).
#
# https://github.com/tj/git-extras
# ==============================================================================

startNewTask "Install git-extras"

sudo apt install git-extras
