#!/usr/bin/env bash

#
# Install apt-transport-https.
#
# This is REQUIRED to let `apt` consume packages over HTTPS.
#

print_step "Installing apt-transport-https."

print_info "Installing/updating apt-transport-https via APT."
superdo apt-get install -y apt-transport-https
