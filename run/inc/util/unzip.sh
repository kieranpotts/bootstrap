#!/usr/bin/env bash

#
# Install unzip.
#
# Unzip is required for installation of other packages, such as
# oh-my-posh.
#

print_step "Installing unzip"

superdo apt-get install -y unzip

unzip -v
