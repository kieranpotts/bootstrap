#!/usr/bin/env bash

#
# Install LazyGit, a TUI for Git.
#
# https://github.com/jesseduffield/lazygit#installation
#

print_step "Installing LazyGit."

# Check if LazyGit is already installed, and which version it is.
installed_version=""
if command -v lazygit >/dev/null 2>&1; then
  installed_version=$(lazygit --version | grep -oP '(?<!git )version=\K[^,]+')
fi

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && [[ -z "${installed_version}" ]]; then
  return 0
fi

# Get the latest version from the GitHub releases page (strip leading `v`).
latest_version=$(gh_latest_tag jesseduffield/lazygit | sed 's/^v//')

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "LazyGit is already installed and at the latest version, v${installed_version}. Skipping."
else

  print_info "Will install/upgrade LazyGit to v${latest_version}."

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Fetch the latest release.
  curl \
    -Lo "${tmp_dir}/lazygit.tar.gz" \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${latest_version}_Linux_x86_64.tar.gz"

  # Check if the download was successful.
  if [[ ! -f "${tmp_dir}/lazygit.tar.gz" ]]; then
    print_error "Failed to download LazyGit package."
    exit 1
  fi

  # Unpack it to the tmp directory.
  tar xf "${tmp_dir}/lazygit.tar.gz" -C "${tmp_dir}" lazygit

  # Install it.
  superdo install "${tmp_dir}/lazygit" /usr/local/bin

  # Remove the temporary directory.
  rm -rf "${tmp_dir}"

  # Print out the installed version, and other version information.
  print_success "Installed/updated LazyGit to v${latest_version}."

fi
