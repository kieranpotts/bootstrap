#!/usr/bin/env bash

#
# Upgrade to the latest packages, without requiring user interaction.
#
# https://serverfault.com/a/839563
# https://askubuntu.com/a/147079
#

print_step "Upgrading software packages"

# Install available upgrades to all existing packages (`upgrade`).
superdo env DEBIAN_FRONTEND=noninteractive apt-get --yes \
  --allow-downgrades \
  --allow-remove-essential \
  --allow-change-held-packages \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold" \
  upgrade

# Upgrade current operating system version (`dist-upgrade`).
superdo env DEBIAN_FRONTEND=noninteractive apt-get --yes \
  --allow-downgrades \
  --allow-remove-essential \
  --allow-change-held-packages \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold" \
  dist-upgrade
