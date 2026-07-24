#!/usr/bin/env bash

#
# Add Bruno's official package registry to APT.
#
# https://docs.usebruno.com/get-started/bruno-basics/download#linux
#

print_step "Adding Bruno's official package registry."

if [[ -f /etc/apt/keyrings/bruno.gpg ]] && [[ -f /etc/apt/sources.list.d/bruno.list ]]; then
  print_info "Bruno's package registry is already configured. Skipping."
  return 0
fi

# Add Bruno's registry key.
curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9FA6017ECABE0266" | gpg --dearmor | superdo tee /etc/apt/keyrings/bruno.gpg > /dev/null

# Set permissions for the GPG key file.
superdo chmod 644 /etc/apt/keyrings/bruno.gpg

# Add the Bruno registry.
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/bruno.gpg] http://debian.usebruno.com/ bruno stable" | superdo tee /etc/apt/sources.list.d/bruno.list

print_success "Bruno's package registry added to APT sources."
