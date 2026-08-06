#!/usr/bin/env bash

#
# Install Obsidian.
#
# References:
# https://obsidian.md/download
#

is_gui_enabled || return 0

print_step "Installing Obsidian."

# Use dpkg to check the installed version. This is preferable to
# using `obsidian --version` because dpkg is authoritative for anything
# install via a .deb package.
installed_version=""
if dpkg -s obsidian >/dev/null 2>&1; then
  installed_version=$(dpkg -s obsidian | grep -oP 'Version: \K[^ ]+')
fi

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && [[ -z "${installed_version}" ]]; then
  return 0
fi

# Find the AMD64 .deb asset URL from the latest release, then extract the
# version number from its filename.
deb_url=$(gh_asset_url obsidianmd/obsidian-releases '_amd64\.deb$')
latest_version=$(echo "${deb_url}" | grep -Po 'obsidian_\K[0-9]+\.[0-9]+\.[0-9]+')

print_info "Latest available version of Obsidian is v${latest_version}."

# Skip the installation if the latest version is already installed.
if [[ -z "${latest_version}" ]]; then
  print_error "Failed to retrieve the latest version of Obsidian. Skipping."
elif [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "Latest version of Obsidian, v${latest_version}, is already installed. Skipping."
else

  print_info "Installing/updating Obsidian from .deb package."

  # Remember the current working directory, so we can change back here later.
  cwd=$(pwd)

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Change to the temporary directory.
  cd "${tmp_dir}" || true

  # Download the .deb (URL discovered at the top of this script).
  wget -q "${deb_url}"

  # Install Obsidian from the downloaded Debian package. Fix (-f) any broken
  # dependencies - this is RECOMMENDED for packages installed directly from
  # Debian packages.
  superdo apt-get install -f -y ./obsidian_*_amd64.deb

  # Change back.
  cd "${cwd}" || true

  # Remove the temporary directory and all its contents.
  rm -rf "${tmp_dir}"

  print_success "Obsidian installed successfully."

fi
