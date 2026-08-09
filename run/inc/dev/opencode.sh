#!/usr/bin/env bash

#
# Install OpenCode.
#
# https://opencode.ai/
#

print_step "Installing OpenCode."

print_info "Installing/updating OpenCode via official install shell script."
curl -fsSL https://opencode.ai/install | bash
