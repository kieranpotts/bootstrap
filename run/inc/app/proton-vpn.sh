#!/usr/bin/env bash

#
# Install the Proton VPN desktop and CLI apps.
#
# https://protonvpn.com/support/official-linux-vpn-debian/
# https://protonvpn.com/support/linux-cli
#

is_gui_enabled || return 0

print_step "Installing Proton VPN."

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! dpkg -s proton-vpn-gnome-desktop >/dev/null 2>&1; then
  return 0
fi

if dpkg -s proton-vpn-gnome-desktop >/dev/null 2>&1; then
  print_info "Proton VPN is already installed. Skipping."
else

  # Discover the latest `protonvpn-stable-release` version from the upstream
  # Debian repo directory listing, and its SHA256 from the Packages file in
  # the same directory.

  repo_base="https://repo.protonvpn.com/debian/dists/stable/main/binary-all"
  latest_version=$(curl -s "${repo_base}/" | grep -oP 'protonvpn-stable-release_\K[0-9]+\.[0-9]+\.[0-9]+(?=_all\.deb)' | sort -V | tail -1)

  if [[ -z "${latest_version}" ]]; then
    print_error "Failed to discover the latest Proton VPN release version. Skipping."
    return 0
  fi

  print_info "Latest available version of Proton VPN is v${latest_version}. Installing from .deb package."

  deb_file="protonvpn-stable-release_${latest_version}_all.deb"
  deb_url="${repo_base}/${deb_file}"

  # Extract the SHA256 for this exact version from the Packages file. The
  # Packages file has stanzas keyed by `Filename:`, and `SHA256:` follows.

  expected_sha256=$(curl -s "${repo_base}/Packages" | awk -v f="dists/stable/main/binary-all/${deb_file}" '
    /^Filename: / { fn = $2 }
    /^SHA256: / && fn == f { print $2; exit }
  ')

  if [[ -z "${expected_sha256}" ]]; then
    print_error "Failed to discover the SHA256 for ${deb_file}. Skipping."
    return 0
  fi

  cwd=$(pwd)
  tmp_dir=$(mktemp -d)
  cd "${tmp_dir}" || true

  wget -q "${deb_url}"

  # Verify integrity.
  echo "${expected_sha256}  ${deb_file}" | sha256sum --check -

  # `--force-confmiss` restores any conffiles (notably the sources.list entry)
  # that have been deleted out from under dpkg. Without this, dpkg short-circuits
  # on a same-version reinstall and apt subsequently can't see the repo, causing
  # `apt-get install proton-vpn-cli` to fail with "no installation candidate".

  superdo dpkg --force-confmiss -i "./${deb_file}"
  superdo apt-get update
  superdo apt-get install -y proton-vpn-gnome-desktop
  superdo apt-get install -y proton-vpn-cli

  cd "${cwd}" || true
  rm -rf "${tmp_dir}"

  print_success "Proton VPN installed successfully."

fi
