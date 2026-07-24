#!/usr/bin/env bash

#
# Install Postman.
#
# https://learning.postman.com/docs/getting-started/installation/installation-and-updates
#

is_gui_enabled || return 0

print_step "Installing Postman."

# Postman ships as a tarball with no version in the download URL, and no
# public versions API. We can't cheaply check whether the installed copy is
# current, so on a fresh system we install; thereafter Postman's built-in
# updater (Settings → Update) keeps it current.

# Check if Postman is already installed.
if [[ -d "/opt/Postman" ]] && [[ -x "/opt/Postman/Postman" ]]; then
  print_info "Postman is already installed. Use Postman's in-app updater (Settings → Update) to upgrade."
else

  # Create temporary directory for download.
  cwd=$(pwd)
  tmp_dir=$(mktemp -d)
  cd "${tmp_dir}" || true

  # Download the latest Linux 64-bit tar.gz.
  print_info "Downloading Postman 64-bit tar for Linux."
  wget -q https://dl.pstmn.io/download/latest/linux64 -O postman-linux64.tar.gz

  # Extract to /opt.
  print_info "Extracting tar to /opt."
  superdo tar -xzf postman-linux64.tar.gz -C /opt

  # Create a symlink in /usr/local/bin for easy access.
  print_info "Symlinking postman binary."
  superdo ln -sf /opt/Postman/Postman /usr/local/bin/postman

  # Create launcher icon.
  print_info "Creating launcher icon."
  mkdir -p ~/.local/share/applications
  cat > ~/.local/share/applications/Postman.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=/opt/Postman/Postman %U
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF

  # Clean up.
  cd "${cwd}" || true
  rm -rf "${tmp_dir}"

  print_success "Postman installed successfully."

fi
