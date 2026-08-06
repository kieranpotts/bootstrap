#!/usr/bin/env bash

#
# Install the tmux multiplexer.
#
# https://github.com/tmux/tmux
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
# The TPM setup is one-time, can be skipped on `./run/update`.
is_updating && return 0

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
