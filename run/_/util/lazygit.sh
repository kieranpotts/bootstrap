#!/bin/bash

# ==============================================================================
# Install LazyGit, a TUI for Git.
#
# https://github.com/jesseduffield/lazygit#installation
# ==============================================================================

startNewTask "Install LazyGit"

# Remember the current working diectory, so we can change back here later.
cwd=$(pwd)

# Create a temporary directory.
tmp_dir=$(mktemp -d)

# Move to the temporary directory.
cd "$tmp_dir"

# Find the latest release.
lazygit_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

# Fetch the latest release.
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${lazygit_version}_Linux_x86_64.tar.gz"

# Unpack it.
tar xf lazygit.tar.gz lazygit

# Install it.
sudo install lazygit /usr/local/bin

# Print out the installed version, and other version information.
installed_lazygit_version=$(lazygit --version | grep -Po 'version=\K[^"]*')
echo "Installed LazyGit version ${installed_lazygit_version}"

# Cleanup.
rm -f lazygit.tar.gz
rm -rf lazygit

# Move back to the original directory.
cd ${cwd}

# Remove the temporary directory.
rm -rf "$tmp_dir"
