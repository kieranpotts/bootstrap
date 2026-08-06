#!/usr/bin/env bash

#
# Install Zed editor.
#
# https://zed.dev/docs/installation
#

is_gui_enabled || return 0

print_step "Installing Zed."

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! command -v zed >/dev/null 2>&1; then
  return 0
fi

print_info "Installing/updating Zed via official install.sh script."
curl -f https://zed.dev/install.sh | sh
