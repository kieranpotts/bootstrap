#!/usr/bin/env bash

#
# Install LazyNpm, a TUI for npm.
#
# https://github.com/jesseduffield/lazynpm#installation
#

print_step "Installing LazyNpm."

# Check if LazyNpm is already installed, and which version it is.
installed_version=""
if command -v lazynpm >/dev/null 2>&1; then
  installed_version=$(lazynpm --version | grep -oP '(?<!git )version=\K[^,]+')
fi

# Get the latest version from the GitHub releases page (strip leading `v`).
latest_version=$(gh_latest_tag jesseduffield/lazynpm | sed 's/^v//')

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "LazyNpm is already installed and at the latest version, v${installed_version}. Skipping."
else

  print_info "Will install/upgrade LazyNpm to v${latest_version}."

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Fetch the latest release.
  curl \
    -Lo "${tmp_dir}/lazynpm.tar.gz" \
    "https://github.com/jesseduffield/lazynpm/releases/latest/download/lazynpm_${latest_version}_Linux_x86_64.tar.gz"

  # Check if the download was successful.
  if [[ ! -f "${tmp_dir}/lazynpm.tar.gz" ]]; then
    print_error "Failed to download LazyNpm package."
    exit 1
  fi

  # Unpack it to the tmp directory.
  tar xf "${tmp_dir}/lazynpm.tar.gz" -C "${tmp_dir}" lazynpm

  # Install it.
  superdo install "${tmp_dir}/lazynpm" /usr/local/bin

  # Remove the temporary directory.
  rm -rf "${tmp_dir}"

  # Print out the installed version, and other version information.
  print_success "Installed/updated LazyNpm to v${latest_version}."

fi
