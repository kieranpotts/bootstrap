#!/usr/bin/env bash

#
# Installs Google Chrome - required for Puppeteer etc.
#
# https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps#install-google-chrome-for-linux
#

print_step "Install Google Chrome"

# Remember the current working directory, so we can change back here later.
cwd=$(pwd)

# Create a temporary directory.
tmp_dir=$(mktemp -d)

# Move to the temporary directory.
cd "$tmp_dir" || true

# Download the latest stable Debian package.
# TODO: Install headless version if no GUI in the current environment.
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# Install the Debian package. The `--fix-missing` option is used to fix missing
# dependencies that may arise during the installation process.
superdo apt-get install -y --fix-missing ./google-chrome-stable_current_amd64.deb

# Move back to the original directory.
cd "${cwd}" || true

# Remove the temporary directory.
rm -rf "$tmp_dir"

google-chrome --version

# @deprecated: This might be causing problems in the devcontainer.
#
# The following is required to eliminate dbus errors when launching Google Chrome
# from WSL. https://github.com/microsoft/WSL/issues/7915#issuecomment-1163333151
# This setup is WSL-specific and should not be run in Docker containers.
# if grep -qi microsoft /proc/version 2>/dev/null; then
#
#   shrc="$HOME/.bashrc"
#   if [ -f "$HOME/local.bashrc" ]; then
#     shrc="$HOME/local.bashrc"
#   fi
#
#   echo '' >> ${shrc}
#   echo '# Fixes for dbus errors when launching Google Chrome from WSL.' >> ${shrc}
#   echo 'export XDG_RUNTIME_DIR=/run/user/$(id -u)' >> ${shrc}
#   echo 'export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus' >> ${shrc}
#
#   # shellcheck disable=SC1090
#   . "${shrc}"
#
#   superdo service dbus start
#   superdo chmod 700 "$XDG_RUNTIME_DIR"
#   superdo chown "$(id -un):$(id -gn)" "$XDG_RUNTIME_DIR"
#   dbus-daemon --session --address="$DBUS_SESSION_BUS_ADDRESS" --nofork --nopidfile --syslog-only &
#
#   # upower also required in WSL.
#   # https://ubuntu.pkgs.org/20.04/ubuntu-main-arm64/upower_0.99.11-1build2_arm64.deb.html
#   superdo apt-get install -y upower
# fi
#
# To launch Chrome, type:
# ---
# $ google-chrome
# ---
