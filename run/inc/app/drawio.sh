#!/usr/bin/env bash

#
# Install Draw.io.
#

print_step "Installing Draw.io."

installed_version=""
if command -v drawio >/dev/null 2>&1; then
  installed_version=$(drawio --version | grep -oP '\K[0-9]+\.[0-9]+\.[0-9]+')
fi

# Find the AMD64 .deb asset URL from the latest release, then extract the
# version number from its filename.
deb_url=$(gh_asset_url jgraph/drawio-desktop 'amd64-[0-9]+\.[0-9]+\.[0-9]+\.deb$')
latest_version=$(echo "${deb_url}" | grep -Po 'drawio-amd64-\K[0-9]+\.[0-9]+\.[0-9]+')

print_info "Latest available version of Draw.io Desktop is v${latest_version}."

if [[ -z "${latest_version}" ]]; then
  print_error "Failed to retrieve the latest version of Draw.io Desktop. Skipping."
elif [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "Latest version of Draw.io Desktop, v${latest_version}, is already installed. Skipping."
else

  print_info "Installing/updating Draw.io from .deb package."

  # Remember the current working directory, so we can change back here later.
  cwd=$(pwd)

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Change to the temporary directory.
  cd "${tmp_dir}" || true

  # Download the .deb (URL discovered at the top of this script).
  wget -q "${deb_url}"

  # Install Draw.io from the downloaded Debian package. Fix (-f) any broken
  # dependencies - this is RECOMMENDED for packages installed directly from
  # Debian packages.
  superdo apt-get install -f -y ./drawio-amd64-*.deb

  # Change back.
  cd "${cwd}" || true

  # Remove the temporary directory and all its contents.
  rm -rf "${tmp_dir}"

  print_success "Draw.io installed successfully."

fi
