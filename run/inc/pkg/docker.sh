#!/usr/bin/env bash

#
# Add Docker's official package repository to APT.
#

print_step "Adding Docker's official package repository."

if [[ -f /etc/apt/keyrings/docker.gpg ]] && [[ -f /etc/apt/sources.list.d/docker.list ]]; then
  print_info "Docker's package repository is already configured. Skipping."
  return 0
fi

# Add Docker's GPG key to APT's keyrings.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | superdo gpg --dearmor --yes --output /etc/apt/keyrings/docker.gpg

# Add repository to the sources list.
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | superdo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Ensure Docker will be installed from the Docker repository, not the default
# Ubuntu/PopOS repository.
apt-cache policy docker-ce > /dev/null

print_success "Docker's package repository added to APT sources."
