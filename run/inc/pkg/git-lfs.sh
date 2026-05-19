#!/usr/bin/env bash

#
# Add Git LFS's official package repository to APT.
#

print_step "Adding Git LFS's official package repository."

if [[ -f /etc/apt/sources.list.d/github_git-lfs.list ]]; then
  print_info "Git LFS's package repository is already configured. Skipping."
  return 0
fi

# The following script automates the configuration of the Git LFS package
# repository, adding it to APT's sources.
(. /etc/lsb-release &&
  curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh |
  superdo env os=ubuntu dist="${DISTRIB_CODENAME}" bash)

print_success "Git LFS's package repository added to APT sources."
