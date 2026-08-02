#!/usr/bin/env bash

#
# Installs Google Chrome - required for Puppeteer etc.
#
# Note, this may install a duplicate Chrome instance if you have already
# installed Chrome via the OS store.
#
# This script does not update Chrome if the installed version is behind the
# latest available version. It is assumed that the user will keep Chrome's
# auto-update feature enabled, else will manually update as needed.
#
# https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps#install-google-chrome-for-linux
#

is_gui_enabled || return 0

print_step "Installing Google Chrome."

# Check if Google Chrome is already installed. We don't need to check for a
# specific version, as we assume it will be auto-updating itself.
if dpkg -s google-chrome-stable >/dev/null 2>&1; then
  print_info "Google Chrome is already installed. Skipping."
else

  print_info "Installing/updating Google Chrome from the official Debian package."

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Download the latest stable Debian package to the temporary directory.
  wget \
    -O "${tmp_dir}/google-chrome-stable_current_amd64.deb" \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

  # Install the Debian package. The `--fix-missing` option is used to fix missing
  # dependencies that may arise during the installation process.
  superdo apt-get install -y --fix-missing "${tmp_dir}/google-chrome-stable_current_amd64.deb"

  # Remove the temporary directory and all its contents.
  rm -rf "${tmp_dir}"

  print_success "Google Chrome installed successfully."

fi
