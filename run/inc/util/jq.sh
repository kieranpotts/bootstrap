#!/usr/bin/env bash

#
# Install jq - command-only JSON processor.
#
# https://github.com/jqlang/jq
#

print_step "Installing jq."

print_info "Installing/updating jq via APT."
superdo apt-get install -y jq
