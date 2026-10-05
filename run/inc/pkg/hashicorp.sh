#!/usr/bin/env bash

#
# Add Hashicorp's official package registry to APT.
#

print_step "Adding Hashicorp's official package registry."

# Always re-fetch the signing key, even when the registry is already configured,
# so a key rotation upstream is picked up on re-run. Otherwise `apt update`
# fails with NO_PUBKEY once HashiCorp rotates its key.
print_info "Refreshing the HashiCorp GPG key."
wget -qO- https://apt.releases.hashicorp.com/gpg | \
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
