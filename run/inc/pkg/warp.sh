#!/usr/bin/env bash

#
# Add the Warp package registry.
#
# https://docs.warp.dev/getting-started/quickstart/installation-and-setup/
#

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
