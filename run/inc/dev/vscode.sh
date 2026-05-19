#!/usr/bin/env bash

#
# Install Visual Studio Code.
#
# https://code.visualstudio.com/docs/
# https://github.com/microsoft/vscode/
#

is_gui_enabled || return 0

print_step "Installing Visual Studio Code."

# The latest available version of Visual Studio Code is installed from the
# VS Code Debian package repository.
#
# VS Code for Linux is not auto-updating. Users must manually update it via the
# package repository or by downloading the latest .deb package. This script will
# therefore also update VS Code, when newer versions are available via APT.

print_info "Installing/updating VS Code via APT."
superdo apt-get install -y code
code --version

print_success "VS Code installed successfully."
