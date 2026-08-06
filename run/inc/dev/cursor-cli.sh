#!/usr/bin/env bash

#
# Installs Cursor CLI.
#
# Usage:
#   $ cursor-agent
#

print_step "Installing Cursor CLI."

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! command -v cursor-agent >/dev/null 2>&1; then
  return 0
fi

print_info "Downloading and running official Cursor CLI installer script."
curl https://cursor.com/install -fsS | bash
