#!/usr/bin/env bash

#
# Installs Dive, a tool for exploring the contents of Docker image layers.
#
# https://github.com/wagoodman/dive
#

print_step "Installing Dive."

# Discover the installed version of Dive, if it exists.
installed_version=""
if dpkg -s dive >/dev/null 2>&1; then
  installed_version=$(dpkg -s dive | grep -oP 'Version: \K[0-9]+\.[0-9]+\.[0-9]+')
fi

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && [[ -z "${installed_version}" ]]; then
  return 0
fi

# Target Dive version we want to install (Dive's tags have a leading `v`).
latest_version=$(gh_latest_tag wagoodman/dive | sed 's/^v//')

print_info "Latest available version of Dive is v${latest_version}."

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "Latest version of Dive, v${latest_version}, is already installed. Skipping."
else

  if [[ "${installed_version}" == "" ]]; then
    print_info "Dive is not currently installed. Will install v${latest_version} via GitHub release channel."
  else
    print_info "Dive v${installed_version} is installed. Will remove this version and install v${latest_version} via GitHub release channel."
  fi

  print_info "Installing/updating Dive from .deb package."

  # Remove the existing version of Dive, if there is one.
  if dpkg -s dive >/dev/null 2>&1; then
    superdo apt-get remove -y dive
  fi

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Fetch the latest .deb file from GitHub releases.
  gh_file="dive_${latest_version}_linux_amd64.deb"
  gh_url="https://github.com/wagoodman/dive/releases/download/v${latest_version}/${gh_file}"

  if ! curl -fL -o "${tmp_dir}/${gh_file}" "${gh_url}"; then
    print_error "Failed to download Dive package from ${gh_url}."
    exit 1
  fi

  # Install the downloaded .deb file.
  superdo dpkg -i "${tmp_dir}/${gh_file}"

  # Install any missing dependencies.
  superdo apt-get install -f -y

  # Remove the temporary directory and all its contents.
  rm -rf "${tmp_dir}"

  # Verify installed version.
  dive --version

  print_success "Dive v${latest_version} installed successfully."

fi
