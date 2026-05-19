#!/usr/bin/env bash

#
# Installs `git-delta`, a paging utility with built-in syntax highlighting. It
# can be used as an alternative to `less` for paging through `git diff` output,
# and other Git commands.
#
# https://dandavison.github.io/delta/
#

print_step "Installing Delta (git-delta)."

# Target Delta version we want to install (Delta's tags have no leading `v`).
latest_version=$(gh_latest_tag dandavison/delta)

print_info "Latest available version of Delta is v${latest_version}."

# Discover the installed version of Delta, if it exists.
installed_version=""
if dpkg -s git-delta >/dev/null 2>&1; then
  installed_version=$(dpkg -s git-delta | grep -oP 'Version: \K[0-9]+\.[0-9]+\.[0-9]+')
fi

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "Latest version of Delta, v${latest_version}, is already installed. Skipping."
else

  if [[ "${installed_version}" == "" ]]; then
    print_info "Delta is not currently installed. Will install v${latest_version} via GitHub release channel. "
  else
    print_info "Delta v${installed_version} is installed. Will remove this version and install v${latest_version} via GitHub release channel."
  fi

  print_info "Installing Delta from .deb package."

  # Remove the existing version of Delta, if there is one.
  if dpkg -s git-delta >/dev/null 2>&1; then
    superdo apt-get remove -y git-delta
  fi

  # Remember the current working directory, so we can change back here later.
  cwd=$(pwd)

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Fetch the latest .deb file from GitHub releases.
  wget \
    -O "${tmp_dir}/git-delta_${latest_version}_amd64.deb" \
    "https://github.com/dandavison/delta/releases/download/${latest_version}/git-delta_${latest_version}_amd64.deb"

  if [[ ! -f "${tmp_dir}/git-delta_${latest_version}_amd64.deb" ]]; then
    print_error "Failed to download git-delta Debian package."
    exit 1
  fi

  # Install the downloaded .deb file.
  superdo dpkg -i "${tmp_dir}/git-delta_${latest_version}_amd64.deb"

  # Install any missing dependencies.
  superdo apt-get install -f -y

  # Move back to the original directory.
  cd "${cwd}" || true

  # Remove the temporary directory and all its contents.
  rm -rf "${tmp_dir}"

  # Verify installed version.
  delta --version

  print_success "Delta v${latest_version} installed successfully."

fi
