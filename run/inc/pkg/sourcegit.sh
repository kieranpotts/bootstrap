#!/usr/bin/env bash

#
# Add SourceGit's package registry (hosted on Codeberg) to APT.
#
# https://github.com/sourcegit-scm/sourcegit
#

# SourceGit is a GUI app (installed by dev/sourcegit.sh only when --gui is
# passed), so there is no point adding its registry without GUI installs.
is_gui_enabled || return 0

print_step "Adding SourceGit's package registry."

if [[ -f /etc/apt/keyrings/sourcegit.asc ]] && [[ -f /etc/apt/sources.list.d/sourcegit.list ]]; then
  print_info "SourceGit's package registry is already configured. Skipping."
  return 0
fi

# Add SourceGit's registry signing key.
curl -fsSL https://codeberg.org/api/packages/yataro/debian/repository.key | superdo tee /etc/apt/keyrings/sourcegit.asc > /dev/null

# Add the SourceGit registry.
echo "deb [signed-by=/etc/apt/keyrings/sourcegit.asc, arch=amd64,arm64] https://codeberg.org/api/packages/yataro/debian generic main" | superdo tee /etc/apt/sources.list.d/sourcegit.list > /dev/null

print_success "SourceGit's package registry added to APT sources."
