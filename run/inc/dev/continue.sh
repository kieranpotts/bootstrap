#!/usr/bin/env bash

#
# Installs Continue CLI.
#
# Requires Node.js v20+.
#
# https://docs.continue.dev/cli/quickstart
#

print_step "Installing Continue CLI."

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! command -v cn >/dev/null 2>&1; then
  return 0
fi

print_info "Downloading and running installer script for Continue CLI."
curl -fsSL https://raw.githubusercontent.com/continuedev/continue/main/extensions/cli/scripts/install.sh | bash

cn --version
