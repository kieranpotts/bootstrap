#!/usr/bin/env bash

#
# Add the Debian package registry for VSCodium.
#
# https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo
# https://github.com/VSCodium/vscodium/
#

# VSCodium is a GUI app (installed by dev/vscodium.sh only when --gui is
# passed), so there is no point adding its registry without GUI installs.
is_gui_enabled || return 0

print_step "Adding VSCodium package registry."

if [[ -f /usr/share/keyrings/vscodium-archive-keyring.asc ]] && [[ -f /etc/apt/sources.list.d/vscodium.list ]]; then
  print_info "VSCodium's package registry is already configured. Skipping."
  return 0
fi

# Add key.
superdo wget https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
  -O /usr/share/keyrings/vscodium-archive-keyring.asc

# Add registry.
echo 'deb [[ arch=amd64,arm64 signed-by=/usr/share/keyrings/vscodium-archive-keyring.asc ]] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' \
    | superdo tee /etc/apt/sources.list.d/vscodium.list

print_success "VSCodium's Debian package registry added to APT sources."
