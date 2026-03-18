#!/bin/bash

# ==============================================================================
# Install Git Large File System (LFS).
#
# https://github.com/git-lfs/git-lfs/blob/main/INSTALLING.md
# ==============================================================================

startNewTask "Install Git LFS"

(. /etc/lsb-release &&
  curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh |
  superdo env os=ubuntu dist="${DISTRIB_CODENAME}" bash)

superdo apt-get install git-lfs

# Enable LFS in Git.
git lfs install
