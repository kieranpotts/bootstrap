#!/usr/bin/env bash

#
# Add KeePassXC's official package registry to APT.
#

# KeePassXC is a GUI app (installed by app/keepassxc.sh only when --gui is passed),
# so there is no point adding its registry without GUI installs.
is_gui_enabled || return 0

print_step "Adding KeePassXC's official package registry."

# The registry is an Ubuntu PPA, which only resolves on the Ubuntu family. Skip on
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
