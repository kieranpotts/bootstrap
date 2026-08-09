#!/usr/bin/env bash

#
# Install the tmux multiplexer.
#
# https://github.com/tmux/tmux
#

print_step "Installing tmux."

print_info "Installing/updating tmux via APT."
superdo apt-get install -y tmux
tmux -V

# TPM (Tmux Plugin Manager) lets ~/.tmux.conf declare plugins (eg.
# tmux-resurrect/tmux-continuum for session persistence across reboots)
# without manual git management.
# https://github.com/tmux-plugins/tpm

if [[ -d "${HOME}/.tmux/plugins/tpm" ]]; then
  print_info "TPM is already installed. Pulling latest."
  git -C "${HOME}/.tmux/plugins/tpm" pull
else
  print_info "Installing TPM."
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
fi
