#!/usr/bin/env bash

#
# Install T3 Code, a minimal GUI for coding agents.
#
# https://t3.codes/
# https://github.com/pingdotgg/t3code
#

print_step "Installing T3 Code."

# Use dpkg to check the installed version, since dpkg is authoritative for
# anything installed via a .deb package.
installed_version=""
if dpkg -s t3code >/dev/null 2>&1; then
  installed_version=$(dpkg -s t3code | grep -oP 'Version: \K[^ ]+')
fi

# Find the AMD64 .deb asset URL from the latest release, then extract the
# version number from its filename.
deb_url=$(gh_asset_url pingdotgg/t3code 'T3-Code-.*-amd64\.deb$')
latest_version=$(echo "${deb_url}" | grep -Po 'T3-Code-\K[0-9]+\.[0-9]+\.[0-9]+')

print_info "Latest available version of T3 Code is v${latest_version}."

if [[ -z "${latest_version}" ]]; then
  print_error "Failed to retrieve the latest version of T3 Code. Skipping."
elif [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "Latest version of T3 Code, v${latest_version}, is already installed. Skipping."
else

  print_info "Installing/updating T3 Code from .deb package."

  # Remember the current working directory, so we can change back here later.
  cwd=$(pwd)

  tmp_dir=$(mktemp -d)
  cd "${tmp_dir}" || true

  wget -q "${deb_url}"

  # Fix (-f) any broken dependencies.
  superdo apt-get install -f -y ./T3-Code-*-amd64.deb

  cd "${cwd}" || true
  rm -rf "${tmp_dir}"

  print_success "T3 Code installed successfully."

fi
