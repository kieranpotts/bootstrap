#!/usr/bin/env bash

#
# Add KeePassXC's official package registry to APT.
#

print_step "Adding KeePassXC's official package registry."

if compgen -G "/etc/apt/sources.list.d/phoerious-ubuntu-keepassxc-*" > /dev/null; then
  print_info "KeePassXC's package registry is already configured. Skipping."
  return 0
fi

superdo add-apt-repository -y ppa:phoerious/keepassxc

print_success "KeePassXC's package registry added to APT sources."
