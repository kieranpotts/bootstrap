#!/usr/bin/env bash

#
# Installs Cursor GUI.
#
# https://cursor.com/download
#

print_step "Installing Cursor GUI."

# Discover the installed version of Cursor, if any.
installed_version=""
if dpkg -s cursor >/dev/null 2>&1; then
  installed_version=$(dpkg -s cursor | grep -oP 'Version: \K[0-9]+\.[0-9]+\.[0-9]+')
fi

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && [[ -z "${installed_version}" ]]; then
  return 0
fi

# Fetch the latest version and .deb download URL from the Cursor API.
release_info_json=$(curl -s "https://cursor.com/api/download?platform=linux-x64&releaseTrack=stable")
latest_version=$(echo "${release_info_json}" | jq -r '.version')
deb_url=$(echo "${release_info_json}" | jq -r '.debUrl')

if [[ -z "${latest_version}" ]]; then
  print_error "Failed to retrieve the latest Cursor version from the Cursor API."
  exit 1
fi

print_info "Latest available version of Cursor is v${latest_version}."

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "Latest version of Cursor, v${latest_version}, is already installed. Skipping."
else

  if [[ "${installed_version}" == "" ]]; then
    print_info "Cursor GUI is not currently installed. Will install v${latest_version}."
  else
    print_info "Cursor GUI v${installed_version} is installed. Will upgrade to v${latest_version}."
  fi

  print_info "Installing/updating Cursor from .deb package."

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Fetch the .deb package.
  print_info "Downloading Cursor v${latest_version} Debian package."

  wget \
    -O "${tmp_dir}/cursor_${latest_version}_amd64.deb" \
    "${deb_url}"

  if [[ ! -f "${tmp_dir}/cursor_${latest_version}_amd64.deb" ]]; then
    print_error "Failed to download Cursor Debian package."
    rm -rf "${tmp_dir}"
    exit 1
  fi

  # Install the downloaded .deb file.
  print_info "Installing Cursor v${latest_version}."
  superdo dpkg -i "${tmp_dir}/cursor_${latest_version}_amd64.deb"

  # Resolve any missing dependencies.
  superdo apt-get install -f -y

  # Remove the temporary directory and all its contents.
  rm -rf "${tmp_dir}"

  print_success "Cursor GUI v${latest_version} installed successfully."

fi
