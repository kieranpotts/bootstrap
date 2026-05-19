#!/usr/bin/env bash

#
# Add Microsoft's GPG signing key, and VS Code package repository.
#
# https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions
#

print_step "Adding Microsoft's official package repository."

if [[ -f /usr/share/keyrings/microsoft.gpg ]] && [[ -f /etc/apt/sources.list.d/vscode.sources ]]; then
  print_info "Microsoft's GPG key and VS Code package repository are already configured. Skipping."
  return 0
fi

# Install the signing key.
print_info "Installing Microsoft GPG key."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
superdo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f microsoft.gpg

# Add the VS Code repository.
print_info "Adding VS Code package repository."
superdo tee /etc/apt/sources.list.d/vscode.sources > /dev/null << 'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

print_success "Microsoft's GPG key and VS Code package repository added to APT sources."
