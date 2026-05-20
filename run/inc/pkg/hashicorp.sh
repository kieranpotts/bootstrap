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
#
# Original script:
#
#   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
#     https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
#     superdo tee /etc/apt/sources.list.d/hashicorp.list
#
# The `lsb_release -cs` command finds the distribution release codename for
# your system. On Linux Mint 22.2, this returns "zara", rather than a
# valid Ubuntu release codename like "jammy" (22.04). Since there's no
# package available for Ubuntu Zara, the package registry will return
# an error when updates are requested.
#
# Our fix is to configure registry to fetch packages for Ubuntu 24.04,
# codename "noble".

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com noble main" | \
  superdo tee /etc/apt/sources.list.d/hashicorp.list

print_success "Hashicorp's package registry added to sources."
