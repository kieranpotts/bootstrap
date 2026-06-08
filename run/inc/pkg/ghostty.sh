#!/usr/bin/env bash

#
# Add registry for community Ubuntu build of Ghostty.
#
# https://ghostty.org/docs/install/binary#linux
# https://github.com/mkasberg/ghostty-ubuntu
#

print_step "Adding community Ubuntu package registry for Ghostty."

if compgen -G "/etc/apt/sources.list.d/mkasberg-ubuntu-ghostty-ubuntu-*" > /dev/null; then
  print_info "Ghostty's package registry is already configured. Skipping."
  return 0
fi

superdo add-apt-repository -y ppa:mkasberg/ghostty-ubuntu

print_success "Community package registry for Ghostty added to APT sources."
