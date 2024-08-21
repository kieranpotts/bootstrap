#!/bin/bash

# ==============================================================================
# System updates.
#
# - Set the system timezone to UTC.
# - Clean up any failed packages, cached from previous builds.
# - Fetch latest updates for all pre-installed software.
# ==============================================================================

startNewTask "Updating the system"

sudo timedatectl set-timezone UTC

# Clean up any packages that were installed to satisfy dependencies,
# but which are no longer needed.
sudo apt-get -y autoremove

# Purge unused packages and clean up the package cache.
sudo apt-get -y --purge remove && sudo apt-get autoclean

# Update the package list.
sudo apt-get update
