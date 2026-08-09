#!/usr/bin/env bash

#
# Installs OpenClaw.
#
# https://openclaw.ai/
#

print_step "Installing OpenClaw."

# `bash -s -- <args>` forwards arguments to a piped install script.
# `--no-onboard` skips the interactive onboarding workflow.
print_info "Installing/updating OpenClaw using official install.sh script."
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard
