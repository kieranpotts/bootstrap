#!/usr/bin/env bash

#
# Install Dropbox.
#
# https://www.dropbox.com/install-linux?_tk=install_view
# https://help.dropbox.com/installs/linux-commands
#

print_step "Installing Dropbox."

# Configuration.
daemon_download_url="https://www.dropbox.com/download?plat=lnx.x86_64"
py_client_download_url="https://linux.dropbox.com/packages/dropbox.py"
py_client_destination_path="/usr/local/bin/dropbox"

# Check if Dropbox is already installed.
is_dropbox_installed() {
  if [[ -f "${py_client_destination_path}" ]]; then
    return 0
  else
    return 1
  fi
}

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! is_dropbox_installed; then
  return 0
fi

if is_dropbox_installed; then
  print_info "Dropbox is already installed. Skipping."
else

  print_info "Installing/updating Dropbox daemon via official installer script."

  # Remember the current working directory, so we can change back here later.
  cwd=$(pwd)

  # Change to the user's home directory.
  cd ~ || true

  # Download, then unpack and execute, the installation script.
  wget -O - "${daemon_download_url}" | tar xzf -

  # Move back to the original directory.
  cd "${cwd}" || true

  print_success "Dropbox daemon installation completed successfully."
  print_warning "You will need to manually run '~/.dropbox-dist/dropboxd' to connect the Dropbox client to our Dropbox account."

  print_info "Installing Dropbox client - direct download of binary."

  # Download the Dropbox Python script and install it directly in a PATH directory.
  superdo curl -L -o "${py_client_destination_path}" "${py_client_download_url}"

  # Make executable.
  superdo chmod +x "${py_client_destination_path}"

  print_success "Dropbox client installed successfully."
  print_info "Use the 'dropbox' command to manage your Dropbox files."

  print_info "Configuring the Dropbox daemon to autostart."

  mkdir -p ~/.config/autostart
  cat > ~/.config/autostart/dropbox.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=dropbox start
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Dropbox
Comment=Start Dropbox daemon
EOF

  print_success "'dropbox start' will run automatically on login."

fi
