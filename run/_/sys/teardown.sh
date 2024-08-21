#!/bin/bash

# ==============================================================================
# Clean up disk space.
# ==============================================================================

startNewTask "Cleaning up disk space"

# Remove package dependencies that are no longer required.
sudo apt-get -y autoremove

# Remove APT cache.
sudo apt-get -y clean

# Clear Bash history.
cat /dev/null > ~/.bash_history && history -c
