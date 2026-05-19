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
