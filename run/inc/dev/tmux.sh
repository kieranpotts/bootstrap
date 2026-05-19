#!/usr/bin/env bash

#
# Install the tmux multiplexer.
#
# https://github.com/tmux/tmux
#

print_step "Install tmux"

superdo apt-get install -y tmux

tmux -V
