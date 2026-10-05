#!/usr/bin/env bash

#
# Add Microsoft's GPG signing key, and various Microsoft package registries.
#
# https://www.microsoft.com/en-us/edge/download/insider?cc=1&form=MA13FJ&cs=4134690573
# https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions
#

print_step "Adding Microsoft's official package registry."

# Always re-fetch the signing key, even when the registries are already
# configured, so a key rotation upstream is picked up on re-run. Otherwise
# `apt update` fails with NO_PUBKEY once Microsoft rotates its key.
print_info "Refreshing Microsoft GPG key."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
superdo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f microsoft.gpg

# Add the Microsoft Edge registry - the stable channel. This is only needed to
# make the `microsoft-edge-stable` package discoverable for the first install
# (see `web/edge.sh`). Thereafter the package maintains this registry itself:
# its postinst script rewrites this same file (dropping `signed-by`, and
# trusting `/etc/apt/trusted.gpg.d/microsoft-edge.gpg` instead).
#
# The file is rewritten on every run, restoring `signed-by` with the refreshed
# key. Otherwise Edge's own (possibly stale) trusted key is used, and a key
# rotation breaks `apt update` until Edge refreshes it.
#
# We deliberately write to Microsoft's own filename. Using any other filename
# leaves two sources for the same URI with differing `Signed-By` values, which
# APT rejects outright - breaking *every* APT operation, not just Edge's.
print_info "Adding Microsoft Edge package registry."
superdo tee /etc/apt/sources.list.d/microsoft-edge.list > /dev/null << 'EOF'
deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main
EOF

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
