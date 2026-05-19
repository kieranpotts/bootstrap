#!/usr/bin/env bash

#
# Install apt-transport-https, which lets `apt` use packages over HTTPS.
# Required by Docker.
#

print_step "Installing apt-transport-https."
print_info "Installing/updating apt-transport-https via APT."

superdo apt-get install -y apt-transport-https
