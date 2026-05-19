#!/bin/bash

#
# System updates.
#
# - Clean up any failed packages, cached from previous builds.
# - Fetch latest updates for all pre-installed software.
#

print_step "Updating system"

# @deprecated: We no longer set the host system timezone to UTC. It's a bit
# annoying having your system clock change when you're in a different timezone!
# Applications SHOULD run in environments in which the timezone is set to UTC;
# containers and VMs should be set to UTC for this purpose. But we don't want to
# force this on the host system.
#if command -v timedatectl &> /dev/null; then
#  superdo timedatectl set-timezone UTC
#else
#  echo "UTC" | superdo tee /etc/timezone
#  superdo dpkg-reconfigure -f noninteractive tzdata
#fi

# Clean up any packages that were installed to satisfy dependencies,
# but which are no longer needed.
superdo apt-get -y autoremove

# Purge unused packages and clean up the package cache.
superdo apt-get -y --purge remove && superdo apt-get autoclean

# Update the package list.
superdo apt-get update
