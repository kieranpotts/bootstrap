#!/usr/bin/env bash

#
# Clean up disk space.
#

print_step "Cleaning up disk space"

# Remove package dependencies that are no longer required.
superdo apt-get -y autoremove

# Remove APT cache.
superdo apt-get -y clean

# Clear Bash history.
cat /dev/null > ~/.bash_history && history -c
