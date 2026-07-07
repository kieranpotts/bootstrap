#!/usr/bin/env bash

#
# Install unzip.
#
# Unzip is required for installation of some packages.
#

print_step "Installing unzip."

print_info "Installing/updating unzip via APT."
superdo apt-get install -y unzip

unzip -v
