#!/bin/bash

# ==============================================================================
# Install Git.
#
#
# Run the following command to check which is the current version of Git
# available via the APT package manager.
#
#     apt-cache policy git
#
# Install the latest version available via the APT package manager:
#
#     sudo apt-get update
#     sudo apt-get install git -y
# ==============================================================================

startNewTask "Install Git"

git_version="2.35.0"

# Install dependencies for the build.
sudo apt-get install libz-dev libssl-dev libcurl4-gnutls-dev libexpat1-dev gettext cmake gcc

# Remember the current working diectory, so we can change back here later.
cwd=$(pwd)

# Create a temporary directory.
tmp_dir=$(mktemp -d)

# Move to the temporary directory.
cd "$tmp_dir"

# Fetch the source code for the target Git version.
wget "https://github.com/git/git/archive/refs/tags/v${git_version}.tar.gz"

# Upack the Git source code.
tar -zxf "v${git_version}.tar.gz"
cd "git-${git_version}"

# Build and install the Git package. This is a slow operation.
make prefix=/usr/local all
sudo make prefix=/usr/local install

# Cleanup.
rm -f "v${git_version}.tar.gz"
rm -rf "git-${git_version}"

# Move back to the original directory.
cd ${cwd}

# Remove the temporary directory.
rm -rf "$tmp_dir"
