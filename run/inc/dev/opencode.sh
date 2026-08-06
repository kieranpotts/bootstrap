#!/usr/bin/env bash

#
# Install OpenCode.
#
# https://opencode.ai/
#

print_step "Installing OpenCode."

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! command -v opencode >/dev/null 2>&1; then
  return 0
fi

print_info "Installing/updating OpenCode via official install shell script."
curl -fsSL https://opencode.ai/install | bash
