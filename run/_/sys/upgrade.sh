#!/bin/bash

# ==============================================================================
# Upgrade to the latest packages, without requiring user interaction.
#
# @see https://serverfault.com/a/839563
# @see https://askubuntu.com/a/147079
# ==============================================================================

startNewTask "Upgrading software packages"

# Install available upgrades to all existing packages (`upgrade`).
sudo DEBIAN_FRONTEND=noninteractive apt-get --yes --allow-downgrades --allow-remove-essential --allow-change-held-packages -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# Upgrade current operating system version (`dist-upgrade`).
sudo DEBIAN_FRONTEND=noninteractive apt-get --yes --allow-downgrades --allow-remove-essential --allow-change-held-packages -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
