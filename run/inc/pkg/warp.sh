#!/usr/bin/env bash

#
# Add the Warp package registry.
#
# https://docs.warp.dev/getting-started/quickstart/installation-and-setup/
#

# Warp is a GUI app (installed by dev/warp.sh only when --gui is passed), so
# there is no point adding its registry without GUI installs.
is_gui_enabled || return 0

print_step "Adding Warp package registry."

if [[ -f /etc/apt/keyrings/warpdotdev.gpg ]] && [[ -f /etc/apt/sources.list.d/warpdotdev.list ]]; then
  print_info "Warp's package registry is already configured. Skipping."
  return 0
fi

# Add key.
superdo wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor > warpdotdev.gpg

superdo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg

# Add registry.
superdo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list'

rm -f warpdotdev.gpg

print_success "Warp's Debian package registry added to APT sources."
