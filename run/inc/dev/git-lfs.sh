#!/bin/bash

#
# Install Git Large File System (LFS).
#
# https://github.com/git-lfs/git-lfs/blob/main/INSTALLING.md
#

startNewTask "Install Git LFS"

curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | superdo bash
superdo apt-get install git-lfs=3.7.1

# Enable LFS in Git.
git lfs install

git lfs version
