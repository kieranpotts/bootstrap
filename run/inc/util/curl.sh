#!/usr/bin/env bash

#
# Install Curl
#

print_step "Installing curl"

superdo apt-get install -y curl

curl --version
