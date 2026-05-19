#!/usr/bin/env bash

#
# Install Curl.
#
# Generally required for downloading files, including Debian packages.
#

print_step "Installing curl."

print_info "Installing/updating curl via APT."
superdo apt-get install -y curl

curl --version
