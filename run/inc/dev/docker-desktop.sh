#!/usr/bin/env bash

#
# Install Docker Desktop.
#
# The following script is based on these installation instructions:
# https://docs.docker.com/desktop/setup/install/linux/ubuntu/
#
# See Docker Desktop's release notes to map version numbers to build numbers.
#

is_gui_enabled || return 0

print_step "Installing Docker Desktop."

# Build version to install.
#
# See Docker Desktop's release notes to map version numbers to build numbers:
# https://docs.docker.com/desktop/release-notes/
#
# For example, the build number for Docker Desktop v4.44.0 is 201307. The
# corresponding build number can be extracted from the URL path for the
# Debian package download, eg.:
# https://desktop.docker.com/linux/main/amd64/201307/docker-desktop-amd64.deb
#
# Unfortunately, we must hard-code the build number, and manually update it
# here when newer versions of Docker Desktop are released, because there is no
# public API endpoint to query this information.
#
# When this build goes stale, Docker's CDN will serve a 404 for the download
# URL and this script will halt with a "Failed to download..." error. That is
# the signal to come back here and bump `target_build` to the latest value
# from the release-notes page above.

target_build="201307"

# Check if Docker Desktop is already installed and, if so, get its build number.
installed_build=""
if dpkg -s docker-desktop >/dev/null 2>&1; then
  installed_build=$(dpkg -s docker-desktop | grep -oP 'Version: \K[^ ]+' | cut -d'-' -f2)
  print_info "Installed build version of Docker Desktop is #${installed_build}."
fi

# Proceed with installation only if the installed build number is different from
# the target build number.
if [[ "${installed_build}" == "${target_build}" ]]; then
  print_info "Docker Desktop build #${target_build} is already installed. Skipping."
else
  print_info "Will install/upgrade Docker Desktop to build #${target_build}."

  print_info "Installing/updating Docker Desktop from .deb package."

  # Create a temporary directory as a target for the Debian package download.
  tmp_dir=$(mktemp -d)

  # Download the latest Docker Desktop Debian package.
  download_url="https://desktop.docker.com/linux/main/amd64/${target_build}/docker-desktop-amd64.deb"

  # `curl -fL` fails on HTTP 4xx/5xx (notably a 404 when the build goes stale)
  # rather than writing the error body into the output file.
  if ! curl -fL -o "${tmp_dir}/docker-desktop-amd64-${target_build}.deb" "${download_url}"; then
    print_error "Failed to download Docker Desktop build #${target_build}. The hardcoded build number is likely stale."
    print_info "Visit https://docs.docker.com/desktop/release-notes/ and update \`target_build\` in this script to the latest build number (extracted from the .deb download URL on that page)."
    rm -rf "${tmp_dir}"
    exit 1
  fi

  # Install from local Debian package.
  superdo apt-get install -y "${tmp_dir}/docker-desktop-amd64-${target_build}.deb"

  # Remove the temporary directory and all its contents.
  rm -rf "${tmp_dir}"

  print_success "Docker Desktop installed successfully."
  print_info "If you are already running Docker Desktop, you may need to restart it to apply the changes."

fi
