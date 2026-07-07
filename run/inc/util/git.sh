#!/usr/bin/env bash

#
# Install Git.
#
# Git must be installed before other dev tools, because some of the scripts to
# install dev tools and applications require Git. For this reason, for the
# purpose of our bootstrap script, we're treating Git as a system utility.
#
# https://github.com/git-lfs/git-lfs/blob/main/INSTALLING.md
#

print_step "Installing Git."

print_info "Installing/updating Git via APT."
superdo apt-get install -y git

git --version
