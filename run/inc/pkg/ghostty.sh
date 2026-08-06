#!/usr/bin/env bash

#
# Add registry for community Ubuntu build of Ghostty.
#
# https://ghostty.org/docs/install/binary#linux
# https://github.com/mkasberg/ghostty-ubuntu
#

print_step "Adding community Ubuntu package registry for Ghostty."

# The registry is an Ubuntu PPA, which only resolves on the Ubuntu family. Skip on
# other Debian-based systems (eg. debian:bookworm-slim), where `add-apt-repository
# ppa:` cannot reach Launchpad and crashes.
is_ubuntu_family || {
  print_info "Non-Ubuntu system detected. Skipping Ghostty's Ubuntu PPA."
  return 0
}

if compgen -G "/etc/apt/sources.list.d/mkasberg-ubuntu-ghostty-ubuntu-*" > /dev/null; then
  print_info "Ghostty's package registry is already configured. Skipping."
  return 0
fi

superdo add-apt-repository -y ppa:mkasberg/ghostty-ubuntu

print_success "Community package registry for Ghostty added to APT sources."
