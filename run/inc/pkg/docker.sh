#!/usr/bin/env bash

#
# Add Docker's official package registry to APT.
#

print_step "Adding Docker's official package registry."

if [[ -f /etc/apt/keyrings/docker.gpg ]] && [[ -f /etc/apt/sources.list.d/docker.list ]]; then
  print_info "Docker's package registry is already configured. Skipping."
  return 0
fi

# Docker publishes separate repositories for Debian and Ubuntu. Using the Ubuntu
# repo on Debian pulls packages built against a newer glibc (eg. containerd.io
# needs libc6 >= 2.38) than Debian bookworm ships (2.36), which breaks the install
# with unmet dependencies. Select the repo and release codename for the host.
if is_ubuntu_family; then
  docker_distro="ubuntu"
  # Force the Ubuntu 24.04 codename "noble": derivatives like Linux Mint report
  # their own codename (eg. "zara"), which is not a valid Ubuntu release on the
  # Docker registry.
  docker_codename="noble"
else
  docker_distro="debian"
  # Use the host's own Debian codename (eg. "bookworm").
  docker_codename="$(. /etc/os-release && printf '%s' "${VERSION_CODENAME:-}")"
fi

# Add Docker's GPG key to APT's keyrings.
curl \
  -fsSL "https://download.docker.com/linux/${docker_distro}/gpg" | superdo gpg --dearmor --yes \
  --output /etc/apt/keyrings/docker.gpg

# Add registry to the sources list.
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/${docker_distro} \
  ${docker_codename} stable" | superdo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Ensure Docker will be installed from the Docker registry, not the default
# Ubuntu/PopOS registry.
apt-cache policy docker-ce > /dev/null

print_success "Docker's package registry added to APT sources."
