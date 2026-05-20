#!/usr/bin/env bash

#
# Add Git LFS's official package registry to APT.
#

print_step "Adding Git LFS's official package registry."

if [[ -f /etc/apt/sources.list.d/github_git-lfs.list ]]; then
  print_info "Git LFS's package registry is already configured. Skipping."
  return 0
fi

# The original script, below, automates the configuration of the Git LFS
# package, customizing it to the local operating system:
#
#   (. /etc/lsb-release &&
#     curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh |
#     superdo env os=ubuntu dist="${DISTRIB_CODENAME}" bash)
#
# The script sources /etc/lsb-release which sets up environment variables like
# the following:
#
#   DISTRIB_ID=LinuxMint
#   DISTRIB_RELEASE=22.2
#   DISTRIB_CODENAME=zara
#   DISTRIB_DESCRIPTION="Linux Mint 22.2 Zara"
#
# The script then passes in the $DISTRIB_CODENAME variable, which on Linux
# Mint 22.2 is "zara". But the script expects an Ubuntu release codename like
# "focal" (20.04), "jammy" (22.04), or "noble" (24.04). The script thus exits
# with an error.
#
# We're forcing the script to assume Ubuntu 24.04 (noble). This may need to
# be manually adjusted for future releases.
#

(curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh |
  superdo env os=ubuntu dist=noble bash)

print_success "Git LFS's package registry added to APT sources."
