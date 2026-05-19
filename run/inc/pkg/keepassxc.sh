#!/usr/bin/env bash

#
# Add KeePassXC's official package repository to APT.
#

print_step "Adding KeePassXC's official package repository."

if compgen -G "/etc/apt/sources.list.d/phoerious-ubuntu-keepassxc-*" > /dev/null; then
  print_info "KeePassXC's package repository is already configured. Skipping."
  return 0
fi

superdo add-apt-repository -y -n ppa:phoerious/keepassxc

print_success "KeePassXC's package repository added to APT sources."
