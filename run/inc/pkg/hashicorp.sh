#!/usr/bin/env bash

#
# Add Hashicorp's official package registry to APT.
#

print_step "Adding Hashicorp's official package registry."

if [[ -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]] && [[ -f /etc/apt/sources.list.d/hashicorp.list ]]; then
  print_info "Hashicorp's package registry is already configured. Skipping."
  return 0
fi

# Install the HashiCorp GPG key.
wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  superdo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Verify the key's fingerprint.
gpg --no-default-keyring \
  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  --fingerprint

# Add the official HashiCorp registry to your system.
# The `lsb_release -cs` command finds the distribution release codename for
# your system, such as `buster`, `groovy`, or `sid`.

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  superdo tee /etc/apt/sources.list.d/hashicorp.list

print_success "Hashicorp's package registry added to sources."
