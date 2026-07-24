#!/usr/bin/env bash

#
# Install LiteLLM.
#
# https://www.litellm.ai/
#

print_step "Installing LiteLLM."

print_info "Installing/updating LiteLLM (with proxy extras) via pipx."
pipx install "litellm[proxy]"

# Ensure the pipx-installed binary is on PATH, ready for the version check.
# pipx installs into ~/.local/bin, which is added to .bashrc by python.sh, but
# it may not yet be in the current bootstrap shell's PATH.

export PATH="${HOME}/.local/bin:${PATH}"
litellm --version

print_success "LiteLLM installed successfully."
