#!/usr/bin/env bash

#
# Add mise's official package registry to APT.
#
# https://mise.jdx.dev/installing-mise.html#apt
#

print_step "Adding mise's official package registry."

# Always re-fetch the signing key, even when the registry is already configured,
# so a key rotation upstream is picked up on re-run. The key is ASCII-armored,
# which APT reads directly from a `.asc` file, so it needs no `gpg --dearmor`.
print_info "Refreshing the mise GPG key."
superdo mkdir -p -m 755 /etc/apt/keyrings
wget -nv -O- https://mise.jdx.dev/gpg-key.pub | superdo tee /etc/apt/keyrings/mise-archive-keyring.asc > /dev/null
superdo chmod go+r /etc/apt/keyrings/mise-archive-keyring.asc

# Add the mise APT source. The registry serves amd64 and arm64 packages.
superdo mkdir -p -m 755 /etc/apt/sources.list.d
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/mise-archive-keyring.asc] https://mise.jdx.dev/deb stable main" | superdo tee /etc/apt/sources.list.d/mise.list > /dev/null

print_success "mise's package registry added to APT sources."
