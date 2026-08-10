#!/usr/bin/env bash

#
# Install Zellij, a terminal multiplexer.
#
# https://zellij.dev/
# https://zellij.dev/documentation/installation
#

print_step "Installing Zellij."

# Check if Zellij is already installed, and which version it is.
installed_version=""
if command -v zellij >/dev/null 2>&1; then
  installed_version=$(zellij --version | grep -oP '\d+\.\d+\.\d+')
fi

# Get the latest version from the GitHub releases page (strip leading `v`).
latest_version=$(gh_latest_tag zellij-org/zellij | sed 's/^v//')

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "Zellij is already installed and at the latest version, v${installed_version}. Skipping."
else

  print_info "Will install/upgrade Zellij to v${latest_version}."

  # Create a temporary directory, and remember where to return to.
  original_dir=$(pwd)
  tmp_dir=$(mktemp -d)
  cd "${tmp_dir}" || exit 1

  # Fetch the latest release.
  curl \
    -Lo zellij.tar.gz \
    "https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"

  # Check if the download was successful.
  if [[ ! -f zellij.tar.gz ]]; then
    print_error "Failed to download Zellij package."
    cd "${original_dir}" || exit 1
    rm -rf "${tmp_dir}"
    exit 1
  fi

  # Unpack it, and install it.
  tar xf zellij.tar.gz
  superdo install zellij /usr/local/bin

  # Restore the working directory, and remove the temporary directory.
  cd "${original_dir}" || exit 1
  rm -rf "${tmp_dir}"

  # Print out the installed version, and other version information.
  print_success "Installed/updated Zellij to v${latest_version}."

fi

zellij --version
