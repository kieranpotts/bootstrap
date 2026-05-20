#!/usr/bin/env bash

#
# Add Mozilla's package registry, and correspondining GPG key, to APT.
#
# https://support.mozilla.org/en-US/kb/install-firefox-linux
#

print_step "Adding Mozilla's official package registry."

if [[ -f /etc/apt/keyrings/packages.mozilla.org.asc ]] \
  && [[ -f /etc/apt/sources.list.d/mozilla.list ]] \
  && [[ -f /etc/apt/preferences.d/mozilla ]]; then
  print_info "Mozilla's package registry is already configured. Skipping."
  return 0
fi

# Import the Mozilla APT registry signing key.
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | superdo tee /etc/apt/keyrings/packages.mozilla.org.asc  > /dev/null

# Verify the fingerprint.
gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "The key fingerprint matches ("$0")."; else print "Verification failed: the fingerprint ("$0") does not match the expected one."}'

# Add the Mozilla APT registry to your sources list - only if it is not already present.
if ! grep -qxF 'deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main' /etc/apt/sources.list.d/mozilla.list 2>/dev/null; then
  echo 'deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main' | superdo tee -a /etc/apt/sources.list.d/mozilla.list
fi

# Configure APT to prioritize the Mozilla registry over other package sources.
superdo tee /etc/apt/preferences.d/mozilla > /dev/null <<EOF
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

print_success "Mozilla's package registry added to APT sources."
