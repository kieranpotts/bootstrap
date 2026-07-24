#!/usr/bin/env bash

#
# Installs Continue CLI.
#
# Requires Node.js v20+.
#
# https://docs.continue.dev/cli/quickstart
#

print_step "Installing Continue CLI."

print_info "Downloading and running installer script for Continue CLI."
curl -fsSL https://raw.githubusercontent.com/continuedev/continue/main/extensions/cli/scripts/install.sh | bash

cn --version
