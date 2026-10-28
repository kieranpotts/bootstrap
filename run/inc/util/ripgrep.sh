#!/usr/bin/env bash

#
# Install ripgrep (`rg`).
#
# ripgrep is a line-oriented search tool that recursively searches the current
# directory for a regex pattern. By default, ripgrep will respect gitignore
# rules and automatically skip hidden files/directories and binary files.
#
# Installed from the `.deb` published with each upstream GitHub release, as the
# version in the Ubuntu archive is old.
#
# https://github.com/burntsushi/ripgrep
# https://github.com/BurntSushi/ripgrep#installation
#

print_step "Installing ripgrep."

# Upstream versions have no `v` prefix. The installed Debian version has a
# packaging suffix (eg. `15.2.0-1`), which is stripped for comparison.
latest_version=$(gh_latest_tag BurntSushi/ripgrep)

installed_version=""
if dpkg -s ripgrep >/dev/null 2>&1; then
  installed_version=$(dpkg -s ripgrep | grep -oP 'Version: \K[^ ]+')
  installed_version="${installed_version%%-*}"
fi

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "ripgrep is already installed and at the latest version, ${installed_version}. Skipping."
else

  print_info "Will install/upgrade ripgrep to ${latest_version}."

  deb_url=$(gh_asset_url BurntSushi/ripgrep '_amd64\.deb$')

  cwd=$(pwd)
  tmp_dir=$(mktemp -d)
  cd "${tmp_dir}" || exit 1

  curl -fLo ripgrep.deb "${deb_url}"
  superdo dpkg -i ripgrep.deb

  cd "${cwd}" || true
  rm -rf "${tmp_dir}"

fi

rg --version
