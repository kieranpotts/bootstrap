#!/usr/bin/env bash

#
# Install ca-certificates.
# Required by Docker.
#

print_step "Installing ca-certificates."
print_info "Installing/updating ca-certificates via APT."

superdo apt-get install -y ca-certificates
