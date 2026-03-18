#!/bin/bash

# ==============================================================================
# System updates.
#
# - Set the system timezone to UTC.
# - Clean up any failed packages, cached from previous builds.
# - Fetch latest updates for all pre-installed software.
# ==============================================================================

startNewTask "Updating the system"

superdo timedatectl set-timezone UTC

# Clean up any packages that were installed to satisfy dependencies,
# but which are no longer needed.
superdo apt-get -y autoremove

# Purge unused packages and clean up the package cache.
superdo apt-get -y --purge remove && superdo apt-get autoclean

# Update the package list.
superdo apt-get update
