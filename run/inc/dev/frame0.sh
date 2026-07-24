#!/usr/bin/env bash

#
# Install Frame0.
#

is_gui_enabled || return 0

print_step "Installing Frame0."

# Discover the latest version from Frame0's downloads page. The .deb filename
# on the page embeds the version, eg. `frame0_1.6.0_amd64.deb`.
latest_version=$(curl -s https://frame0.app/download | grep -oP 'frame0_\K[0-9]+\.[0-9]+\.[0-9]+(?=_amd64\.deb)' | head -1)

if [[ -z "${latest_version}" ]]; then
  print_error "Failed to discover the latest Frame0 version from https://frame0.app/download. Skipping."
  return 0
fi

deb_url="https://files.frame0.app/releases/linux/x64/frame0_${latest_version}_amd64.deb"

print_info "Latest available version of Frame0 is v${latest_version}."

# Check installed version (if any).
installed_version=""
if dpkg -s frame0 >/dev/null 2>&1; then
  installed_version=$(dpkg -s frame0 | grep -oP 'Version: \K[0-9]+\.[0-9]+\.[0-9]+')
fi

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "Latest version of Frame0, v${latest_version}, is already installed. Skipping."
else

  print_info "Installing/updating Frame0 from .deb package."

  cwd=$(pwd)
  tmp_dir=$(mktemp -d)
  cd "${tmp_dir}" || true

  wget -q "${deb_url}"
  superdo apt-get -f install "./frame0_${latest_version}_amd64.deb"

  cd "${cwd}" || true
  rm -rf "${tmp_dir}"

  print_success "Frame0 installed successfully."
fi
