#!/usr/bin/env bash

#
# Install Git LFS (Large File System).
#
# Depends on `pkg/git-lfs.sh`, which adds the required
# package registry to APT's sources.
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
# `git lfs install` is one-time and can be skipped on `./run/update`.
is_updating && return 0

print_step "Installing Git LFS."

print_info "Installing/updating Git LFS via APT."
superdo apt-get install -y git-lfs

# Enable LFS in Git.
git lfs install

print_success "Git LFS extension installed successfully."
