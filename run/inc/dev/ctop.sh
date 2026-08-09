#!/usr/bin/env bash

#
# Install ctop, a top-like interface for container metrics.
#
# https://github.com/bcicen/ctop#installation
#

print_step "Installing ctop."

# Check if ctop is already installed, and which version it is.
installed_version=""
if command -v ctop >/dev/null 2>&1; then
  installed_version=$(ctop -v | grep -oP '\d+\.\d+\.\d+')
fi

# Get the latest version from the GitHub releases page (strip leading `v`).
latest_version=$(gh_latest_tag bcicen/ctop | sed 's/^v//')

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "ctop is already installed and at the latest version, v${installed_version}. Skipping."
else

  print_info "Will install/upgrade ctop to v${latest_version}."

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Compile the download URL for the latest release. ctop ships a raw binary
  # asset (no archive), so it is installed directly with no unpack step.
  gh_file="ctop-${latest_version}-linux-amd64"
  gh_url="https://github.com/bcicen/ctop/releases/download/v${latest_version}/${gh_file}"

  # Download the release binary. `-f` fails on HTTP 4xx/5xx (eg. a 404 when
  # the asset URL is wrong) instead of writing the error body to the file.
  if ! curl -fL -o "${tmp_dir}/ctop" "${gh_url}"; then
    print_error "Failed to download ctop package from ${gh_url}."
    exit 1
  fi

  # Install/update the local binary (`install` sets the executable bit).
  superdo install "${tmp_dir}/ctop" /usr/local/bin

  # Remove the temporary directory and its temporary artifacts.
  rm -rf "${tmp_dir}"

  # Print out the installed version, and other version information.
  print_success "Installed/updated ctop to v${latest_version}."

fi
