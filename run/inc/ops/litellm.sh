#!/usr/bin/env bash

#
# Install LiteLLM.
#
# https://www.litellm.ai/
#

print_step "Installing LiteLLM."

# pipx installs into ~/.local/bin, which is added to .bashrc by python.sh, but
# it may not yet be in the current bootstrap shell's PATH. Export it now, so
# it's ready for both the presence check below and the version check at the
# end.
export PATH="${HOME}/.local/bin:${PATH}"

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! command -v litellm >/dev/null 2>&1; then
  return 0
fi

print_info "Installing/updating LiteLLM (with proxy extras) via pipx."
pipx install "litellm[proxy]"

litellm --version

print_success "LiteLLM installed successfully."
