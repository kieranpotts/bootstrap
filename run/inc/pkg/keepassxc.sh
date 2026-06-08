#!/usr/bin/env bash

#
# Add KeePassXC's official package registry to APT.
#

print_step "Adding KeePassXC's official package registry."

# Installed from an Ubuntu PPA, which only resolves on the Ubuntu family. Skip on
# other Debian-based systems (eg. debian:bookworm-slim), where `add-apt-repository
# ppa:` cannot reach Launchpad and crashes.
is_ubuntu_family || {
  print_info "Non-Ubuntu system detected. Skipping KeePassXC's Ubuntu PPA."
  return 0
}

if compgen -G "/etc/apt/sources.list.d/phoerious-ubuntu-keepassxc-*" > /dev/null; then
  print_info "KeePassXC's package registry is already configured. Skipping."
  return 0
fi

superdo add-apt-repository -y ppa:phoerious/keepassxc

print_success "KeePassXC's package registry added to APT sources."
