#!/usr/bin/env bash

#
# Install the Proton Mail desktop app.
#
# https://proton.me/support/mail-desktop-app
#

is_gui_enabled || return 0

print_step "Installing Proton Mail."

# Proton Mail does not appear to have versioned releases, so we will
# just check if a binary already exists for it. `which` returns a non-zero
# exit code when the given command is not found. Suppress error output.

if which proton-mail >/dev/null 2>&1; then
  print_info "Proton Mail is already installed. Skipping."
else
  print_info "Proton Mail is not installed. Proceeding with installation from .deb package."

  # The Proton Mail app for Linux is currently in beta.
  deb_url="https://proton.me/download/mail/linux/ProtonMail-desktop-beta.deb"

  cwd=$(pwd)
  tmp_dir=$(mktemp -d)
  cd "${tmp_dir}" || true

  wget -q "${deb_url}"
  superdo apt-get install -f -y ./ProtonMail-desktop-beta.deb

  cd "${cwd}" || true
  rm -rf "${tmp_dir}"

  print_success "Proton Mail installed successfully."
fi
