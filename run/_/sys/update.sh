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

sudo apt-get -y autoremove
sudo apt-get -y --purge remove && sudo apt-get autoclean

sudo apt-get update
