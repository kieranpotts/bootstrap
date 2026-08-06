#!/usr/bin/env bash

#
# Install editorconfig-checker (`ec`), a linter that validates files against
# the project's `.editorconfig` rules.
#
# https://github.com/editorconfig-checker/editorconfig-checker
#

print_step "Installing editorconfig-checker."

# Check if it's already installed, and which version.
installed_version=""
if command -v ec >/dev/null 2>&1; then
  installed_version=$(ec -version | sed 's/^v//')
fi

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && [[ -z "${installed_version}" ]]; then
  return 0
fi

# Get the latest version from the GitHub releases page (strip leading `v`).
latest_version=$(gh_latest_tag editorconfig-checker/editorconfig-checker | sed 's/^v//')

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "editorconfig-checker is already installed and at the latest version, v${latest_version}. Skipping."
else

  print_info "Will install/upgrade editorconfig-checker to v${latest_version}."

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Fetch the latest release. Upstream ships a prebuilt binary per OS/arch,
  # no apt package or .deb is published.
  curl \
    -Lo "${tmp_dir}/ec.tar.gz" \
    "https://github.com/editorconfig-checker/editorconfig-checker/releases/download/v${latest_version}/ec-linux-amd64.tar.gz"

  # Check if the download was successful.
  if [[ ! -f "${tmp_dir}/ec.tar.gz" ]]; then
    print_error "Failed to download editorconfig-checker package."
    exit 1
  fi

  # Unpack it to the tmp directory. The archive holds `bin/ec-linux-amd64`.
  tar xf "${tmp_dir}/ec.tar.gz" -C "${tmp_dir}" bin/ec-linux-amd64

  # Install it, renaming to the short `ec` command upstream itself documents.
  superdo install "${tmp_dir}/bin/ec-linux-amd64" /usr/local/bin/ec

  # Remove the temporary directory.
  rm -rf "${tmp_dir}"

  print_success "Installed/updated editorconfig-checker to v${latest_version}."

fi
