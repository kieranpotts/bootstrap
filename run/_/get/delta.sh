#!/bin/bash

# ==============================================================================
# Installs `git-delta`, a paging utility with built-in syntax highlighting. It
# can be used as an alternative to `less` for paging through `git diff` output,
# and other Git commands.
#
# https://dandavison.github.io/delta/
# ==============================================================================

startNewTask "Install delta"

# Remove any existing installations.
sudo apt remove git-delta -y
sudo apt remove git-delta-musl -y

# Version to install.
delta_version="0.18.0"

# Remember the current working diectory, so we can change back here later.
cwd=$(pwd)

# Create a temporary directory.
tmp_dir=$(mktemp -d)

# Move to the temporary directory.
cd "$tmp_dir"

# Fetch the latest .deb file from GitHub releases.
wget "https://github.com/dandavison/delta/releases/download/${delta_version}/git-delta_${delta_version}_amd64.deb"

# Install the downloaded .deb file.
sudo dpkg -i "git-delta_${delta_version}_amd64.deb"

# Install any missing dependencies.
sudo apt-get install -f

# Move back to the original directory.
cd ${cwd}

# Remove the temporary directory.
rm -rf "$tmp_dir"
