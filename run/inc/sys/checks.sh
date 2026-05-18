#!/bin/bash

#
# Initial system compatibility checks.
#
# Fails fast on unsupported environments and prompts the user before
# continuing on untested Ubuntu versions. Prints the detected OS, version,
# and architecture so provisioning logs are self-describing.
#

startNewTask "Check system compatibility"

# Hard requirement: Debian-based Linux for `apt-get` / `dpkg`.
if [ ! -f /etc/debian_version ]; then
  print_error "This script requires a Debian-based Linux distribution."
  if [ -f /etc/os-release ]; then
    grep "PRETTY_NAME" /etc/os-release
  fi
  print_info "Aborting bootstrap script."
  exit 1
fi

# Pull distribution details (ID, VERSION_ID, PRETTY_NAME, …) into the
# current shell so they can be referenced below.
source /etc/os-release
print_success "Detected ${PRETTY_NAME:-${ID:-Debian-based Linux}}."

# Prompt before continuing on Ubuntu versions outside the tested set.
if [ "${ID:-}" = "ubuntu" ] && [[ "${VERSION_ID:-}" != "22.04" && "${VERSION_ID:-}" != "24.04" ]]; then
  print_warning "Ubuntu ${VERSION_ID:-unknown} is outside the tested set (22.04, 24.04)."
  read -r -p "Continue anyway? (y/N) " -n 1
  echo
  if [[ ! ${REPLY} =~ ^[Yy]$ ]]; then
    print_info "Bootstrap script aborted."
    exit 1
  fi
fi

# Architecture check. ROCm specifically requires x86_64; the rest of the
# script is portable, so a non-x86_64 host warns rather than fails.
arch=$(uname -m)
if [ "${arch}" != "x86_64" ]; then
  print_warning "Detected ${arch} architecture. The ROCm install step requires x86_64 and will likely fail."
else
  print_success "Detected ${arch} architecture."
fi
