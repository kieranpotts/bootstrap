#!/usr/bin/env bash

#
# Install LazyDocker, a TUI for Docker and Docker Compose.
#
# Installation script based on:
# https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh
#

print_step "Installing LazyDocker."

# Check if LazyDocker is already installed, and which version it is.
installed_version=""
if command -v lazydocker >/dev/null 2>&1; then
  installed_version=$(lazydocker --version | grep "Version:" | awk '{print $2}')
fi

# Get the latest version from the GitHub releases page (strip leading `v`).
latest_version=$(gh_latest_tag jesseduffield/lazydocker | sed 's/^v//')

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "LazyDocker is already installed and at the latest version, v${installed_version}. Skipping."
else

  print_info "Will install/upgrade LazyDocker to v${latest_version}."

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Compile the download URL for the latest release.
  gh_file="lazydocker_${latest_version//v/}_$(uname -s)_x86_64.tar.gz"
  gh_url="https://github.com/jesseduffield/lazydocker/releases/download/v${latest_version}/${gh_file}"

  # Download the release archive. `-f` fails on HTTP 4xx/5xx (eg. a 404 when
  # the asset URL is wrong) instead of writing the error body to the file.
  if ! curl -fL -o "${tmp_dir}/lazydocker.tar.gz" "${gh_url}"; then
    print_error "Failed to download LazyDocker package from ${gh_url}."
    exit 1
  fi

  # Unpack the download into the tmp directory.
  tar -xzvf "${tmp_dir}/lazydocker.tar.gz" -C "${tmp_dir}" lazydocker

  # Install/update the local binary.
  superdo install "${tmp_dir}/lazydocker" /usr/local/bin

  # Remove the temporary directory and its temporary artifacts.
  rm -rf "${tmp_dir}"

  # Print out the installed version, and other version information.
  print_success "Installed/updated LazyDocker to v${latest_version}."

fi
