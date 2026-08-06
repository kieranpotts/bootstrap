#!/usr/bin/env bash

#
# Installs Ollama.
#
# https://ollama.com/
#

print_step "Installing Ollama."

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! command -v ollama >/dev/null 2>&1; then
  return 0
fi

print_info "Installing/updating Ollama via official install.sh script."
curl -fsSL https://ollama.com/install.sh | sh

print_info "Enabling Ollama service by default, starting immediately."
superdo systemctl enable ollama
superdo systemctl start ollama
