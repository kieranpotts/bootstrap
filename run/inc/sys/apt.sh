#!/bin/bash

#
# APT package manager setup and configuration.
#

print_step "Configuring APT."

print_info "Adding directory to store APT repository keys."

superdo install -d -m 0755 /etc/apt/keyrings
