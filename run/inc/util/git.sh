#!/bin/bash

#
# Install Git.
#

print_step "Install Git"

superdo apt-get install -y git

git --version
