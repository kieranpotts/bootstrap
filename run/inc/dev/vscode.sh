#!/bin/bash

#
# Install Visual Studio Code.
#
# https://code.visualstudio.com/docs/
# https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions
# https://github.com/microsoft/vscode/
#
# The latest available version of Visual Studio Code is installed from the
# VS Code Debian package repository.
#
# VS Code for Linux is not auto-updating. Users must manually update it via the
# package repository or by downloading the latest .deb package. This script will
# therefore also update VS Code, when newer versions are available via APT.
#

is_gui_enabled || return 0

startNewTask "Install Visual Studio Code"

# Remember the current working directory, so we can change back here later.
cwd=$(pwd)

# Create a temporary directory.
tmp_dir=$(mktemp -d)

# Move to the temporary directory.
cd "$tmp_dir" || true

# Install Microsoft's GPG signing key.
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
superdo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f microsoft.gpg

# Move back to the original directory.
cd "${cwd}" || true

# Remove the temporary directory.
rm -rf "$tmp_dir"

# Add the VS Code apt source.
superdo tee /etc/apt/sources.list.d/vscode.sources > /dev/null << 'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

# Install VS Code.
superdo apt-get update
superdo apt-get install -y code
