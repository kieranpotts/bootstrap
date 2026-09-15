#!/usr/bin/env bash

#
# Add the Debian package registry for Teams for Linux.
#
# https://ismaelmartinez.github.io/teams-for-linux/installation/
#

print_step "Adding Teams for Linux package registry."

if [[ -f /etc/apt/keyrings/teams-for-linux.asc ]] && [[ -f /etc/apt/sources.list.d/teams-for-linux-packages.sources ]]; then
  print_info "Teams for Linux's package registry is already configured. Skipping."
  return 0
fi

# Add key.
superdo mkdir -p /etc/apt/keyrings
superdo wget -qO /etc/apt/keyrings/teams-for-linux.asc \
  https://repo.teamsforlinux.de/teams-for-linux.asc

# Add registry.
{
  echo "Types: deb"
  echo "URIs: https://repo.teamsforlinux.de/debian/"
  echo "Suites: stable"
  echo "Components: main"
  echo "Signed-By: /etc/apt/keyrings/teams-for-linux.asc"
  echo "Architectures: amd64"
} | superdo tee /etc/apt/sources.list.d/teams-for-linux-packages.sources > /dev/null

print_success "Teams for Linux's Debian package registry added to APT sources."
