#!/usr/bin/env bash

#
# Install Make.
#

print_step "Install Make"

superdo apt-get install -y make

make --version
