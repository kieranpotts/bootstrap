#!/usr/bin/env bash

#
# Installs Ollama.
#
# https://ollama.com/
#

print_step "Installing Ollama."

print_info "Installing/updating Ollama via official install.sh script."
curl -fsSL https://ollama.com/install.sh | sh

print_info "Enabling Ollama service by default, starting immediately."
superdo systemctl enable ollama
superdo systemctl start ollama
