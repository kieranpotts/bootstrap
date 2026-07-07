#!/usr/bin/env bash

#
# Add Microsoft's GPG signing key, and various Microsoft package registries.
#
# https://www.microsoft.com/en-us/edge/download/insider?cc=1&form=MA13FJ&cs=4134690573
# https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions
#

print_step "Adding Microsoft's official package registry."

if [[ -f /usr/share/keyrings/microsoft.gpg ]] && [[ -f /etc/apt/sources.list.d/vscode.sources ]]; then
  print_info "Microsoft's GPG key and VS Code package registry are already configured. Skipping."
  return 0
fi

# Install the signing key.
print_info "Installing Microsoft GPG key."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
superdo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f microsoft.gpg

# Add the Microsoft Edge registry - the stable channel.
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] \
  https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-stable.list'

# Add the VS Code registry.
print_info "Adding VS Code package registry."
superdo tee /etc/apt/sources.list.d/vscode.sources > /dev/null << 'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

print_success "Microsoft's GPG key and VSCode/Edge package registries added to APT sources."
