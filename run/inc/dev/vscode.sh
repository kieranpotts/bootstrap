#!/usr/bin/env bash

#
# Install Visual Studio Code.
#
# Depends on `pkg/microsoft.sh`, which adds Microsoft's VS Code
# package registry.
#
# https://code.visualstudio.com/docs/
# https://github.com/microsoft/vscode/
#

print_step "Installing Visual Studio Code."

# The latest available version of Visual Studio Code is installed from the
# VS Code Debian package repository.
#
# VS Code for Linux is not auto-updating. Users must manually update it via the
# package repository or by downloading the latest .deb package. This script will
# therefore also update VS Code, when newer versions are available via APT.

print_info "Installing/updating VS Code via APT."

# The package's postinst script asks (via debconf) whether to add Microsoft's
# repository, which blocks an unattended/away-from-keyboard run while holding
# the dpkg lock. The repository is already registered by `pkg/microsoft.sh`,
# and letting the postinst add its own source would duplicate it with differing
# `Signed-By` values, which APT rejects. So preseed the answer as "no".
echo "code code/add-microsoft-repo boolean false" | superdo debconf-set-selections

superdo apt-get install -y code
code --version
