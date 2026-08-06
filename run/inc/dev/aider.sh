#!/usr/bin/env bash

#
# Install Aider.
#
# https://aider.chat/docs/install.html
#

print_step "Installing Aider."

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! command -v aider >/dev/null 2>&1; then
  return 0
fi

print_info "Installing aider installer in pipx."
python3 -m pipx install aider-install

print_info "Running aider installer."
aider-install
