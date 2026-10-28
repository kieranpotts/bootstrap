#!/usr/bin/env bash

#
# Installs OpenClaw.
#
# https://openclaw.ai/
#

print_step "Installing OpenClaw."

# The OpenClaw package requires Node >=24.22.1 <25 || >=26.12.1. If the active
# Node is not supported, the installer picks the first NVM-managed version that
# passes its own looser check - which can be a stale v26.x that the package
# itself then rejects. Activate the pinned Node version (see exec/node.sh) so
# the installer keeps the active runtime and does not go scanning.
if command -v nvm >/dev/null 2>&1; then
  nvm use 26.12.1 >/dev/null
fi

# `bash -s -- <args>` forwards arguments to a piped install script.
# `--no-onboard` skips the interactive onboarding workflow.
print_info "Installing/updating OpenClaw using official install.sh script."
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard
