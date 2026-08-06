#!/usr/bin/env bash

#
# Install Visual Studio Code Insiders.
#
# https://code.visualstudio.com/insiders/
# https://github.com/microsoft/vscode/
#

is_gui_enabled || return 0

print_step "Installing Visual Studio Code Insiders."

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! dpkg -s code-insiders >/dev/null 2>&1; then
  return 0
fi

# VS Code Insiders is installed from the latest available Debian package,
# downloaded directly from Microsoft's update servers. The download URL always
# resolves to the latest build, so this script will replace whatever version
# is currently installed with the latest nightly build – no version checks
# will be done.

# Create a temporary directory as a target for the Debian package download.
tmp_dir=$(mktemp -d)

# Download the latest VS Code Insiders Debian package.
download_url="https://update.code.visualstudio.com/latest/linux-deb-x64/insider"
wget \
  -O "${tmp_dir}/code-insiders-amd64.deb" \
  "${download_url}"

if [[ ! -f "${tmp_dir}/code-insiders-amd64.deb" ]]; then
  print_error "Failed to download VS Code Insiders package."
  exit 1
fi

# Install from local Debian package.
superdo apt-get install -y "${tmp_dir}/code-insiders-amd64.deb"

# Remove the temporary directory and all its contents.
rm -rf "${tmp_dir}"

print_success "VS Code Insiders installed successfully."
