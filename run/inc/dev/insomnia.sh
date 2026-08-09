#!/usr/bin/env bash

#
# Install Insomnia.
#
# https://developer.konghq.com/insomnia/
#

print_step "Installing Insomnia."

# Insomnia's update URL is opaque (the redirect target doesn't expose a
# version in a stable, parseable way), so we can't cheaply check whether
# the installed version is current. We do the simple thing: install on a
# fresh system; on subsequent runs, the user updates Insomnia in-app.

if dpkg -s insomnia >/dev/null 2>&1; then
  print_info "Insomnia is already installed. Use the in-app updater to upgrade."

else

  # Create temporary directory for download.
  cwd=$(pwd)
  tmp_dir=$(mktemp -d)
  cd "${tmp_dir}" || true

  # Download the latest Ubuntu deb package (showing progress to the terminal).
  print_info "Downloading Insomnia .deb package."
  wget 'https://updates.insomnia.rest/downloads/ubuntu/latest?app=com.insomnia.app&source=website' -O insomnia.deb

  # Install the deb package.
  print_info "Installing/updating Insomnia from .deb package."
  superdo dpkg -i insomnia.deb

  # Fix any missing dependencies.
  print_info "Fixing any missing dependencies."
  superdo apt-get install -f -y

  # Clean up.
  cd "${cwd}" || true
  rm -rf "${tmp_dir}"

  print_success "Insomnia installed successfully."

fi
