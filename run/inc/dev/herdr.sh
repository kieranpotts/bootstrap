#!/usr/bin/env bash

#
# Install Herdr, a terminal multiplexer and runtime for coding agents.
#
# https://herdr.dev/
# https://herdr.dev/docs/install/
# https://github.com/herdrdev/herdr
#

print_step "Installing Herdr."

# Check if Herdr is already installed, and which version it is.
installed_version=""
if command -v herdr >/dev/null 2>&1; then
  installed_version=$(herdr --version | grep -oP '\d+\.\d+\.\d+' | head -n1)
fi

# Get the latest version from the GitHub releases page (strip leading `v`).
latest_version=$(gh_latest_tag herdrdev/herdr | sed 's/^v//')

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "Herdr is already installed and at the latest version, v${installed_version}. Skipping."
else

  print_info "Will install/upgrade Herdr to v${latest_version}."

  # Create a temporary directory, and remember where to return to.
  original_dir=$(pwd)
  tmp_dir=$(mktemp -d)
  cd "${tmp_dir}" || exit 1

  # Fetch the latest release. The asset is a bare binary.
  curl \
    -Lo herdr \
    "https://github.com/herdrdev/herdr/releases/latest/download/herdr-linux-x86_64"

  # Check if the download was successful.
  if [[ ! -s herdr ]]; then
    print_error "Failed to download Herdr binary."
    cd "${original_dir}" || exit 1
    rm -rf "${tmp_dir}"
    exit 1
  fi

  superdo install herdr /usr/local/bin

  # Restore the working directory, and remove the temporary directory.
  cd "${original_dir}" || exit 1
  rm -rf "${tmp_dir}"

  print_success "Installed/updated Herdr to v${latest_version}."

fi

herdr --version
