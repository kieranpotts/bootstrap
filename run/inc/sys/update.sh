#!/usr/bin/env bash

#
# System updates.
#
# - Clean up any failed packages, cached from previous builds.
# - Fetch latest updates for all pre-installed software.
#

print_step "Updating system."

# DEPRECATED: We no longer set the host system timezone to UTC. It's a bit
# annoying having your system clock change when you're in a different timezone!
# Applications SHOULD run in environments in which the timezone is set to UTC;
# containers and VMs should be set to UTC for this purpose. But we don't want to
# force this on the host system.
# if command -v timedatectl &> /dev/null; then
#   superdo timedatectl set-timezone UTC
# else
#   echo "UTC" | superdo tee /etc/timezone
#   superdo dpkg-reconfigure -f noninteractive tzdata
# fi

# Clean up any packages that were installed to satisfy dependencies,
# but which are no longer needed.
superdo apt-get -y autoremove

# Purge unused packages and clean up the package cache.
superdo apt-get -y --purge remove && superdo apt-get autoclean

# Update the package list.
#
# Retry a few times on failure. This has been observed to fail transiently
# (exit 100) when a third-party APT mirror is mid-sync and briefly serves a
# Packages file whose declared size doesn't match what's fetched (eg.
# "File has unexpected size ... Mirror sync in progress?" from
# packages.mozilla.org) - the same mirror is fine seconds later.
attempt=1
until superdo apt-get update; do
  if (( attempt >= 3 )); then
    print_error "apt-get update failed after ${attempt} attempts."
    exit 1
  fi
  print_warning "apt-get update failed (attempt ${attempt}/3). Retrying in 5s..."
  attempt=$((attempt + 1))
  sleep 5
done
