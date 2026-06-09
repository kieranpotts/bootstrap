#!/usr/bin/env bash

#
# Initial system compatibility checks.
#
# Fails fast on unsupported environments and prompts the user before
# continuing on untested Ubuntu versions. Prints the detected OS, version,
# and architecture so provisioning logs are self-describing.
#

print_step "Checking system compatibility."

# Hard requirement: Debian-based Linux for `apt-get` / `dpkg`.
if [[ ! -f /etc/debian_version ]]; then
  print_error "Require a Debian-based Linux distribution."
  if [[ -f /etc/os-release ]]; then
    grep "PRETTY_NAME" /etc/os-release
  fi
  print_info "Aborting bootstrap script."
  exit 1
fi
print_success "Detected Debian-based Linux distribution."

# Architecture check. Every download URL in this bootstrap hardcodes
# amd64/x86_64, so non-x86_64 hosts will fail mid-run with confusing errors.
# Fail fast instead.
arch=$(uname -m)
if [[ "${arch}" != "x86_64" ]]; then
  print_error "Detected ${arch} architecture. This bootstrap targets x86_64 only — package URLs are hardcoded and will fail."
  print_info "Aborting bootstrap script."
  exit 1
fi
print_success "Detected ${arch} architecture."

# Pull distribution details (ID, VERSION_ID, PRETTY_NAME, …) into the
# current shell so they can be referenced below.
. /etc/os-release
print_success "Detected ${PRETTY_NAME:-${ID:-Debian-based Linux}}."

# This bootstrap is tested against the current Ubuntu LTS releases. Only gate on
# this when running on the Ubuntu family (Ubuntu, Pop!_OS, …); other Debian-based
# distributions — including Debian itself, as used by container base images like
# debian:bookworm-slim — use a different versioning scheme (VERSION_ID=12) and
# are allowed through.
if is_ubuntu_family; then
  if [[ "${VERSION_ID:-}" != "22.04" && "${VERSION_ID:-}" != "24.04" ]]; then
    print_error "This bootstrap is tested on Ubuntu 22.04 and 24.04."
    print_error "Your version (${VERSION_ID:-unknown}) may not be fully supported."

    # Only prompt when attached to a terminal. In non-interactive contexts (eg.
    # a `docker build` layer) there is no TTY to answer the prompt, so continue
    # rather than blocking on a `read` that would receive EOF and abort.
    if [[ -t 0 ]]; then
      read -p "Do you want to continue? (y/N): " -n 1 -r
      echo

      if [[ ! ${REPLY} =~ ^[Yy]$ ]]; then
        print_info "Bootstrap script aborted."
        exit 1
      fi
    else
      print_info "Non-interactive shell detected; continuing."
    fi
  fi
fi
