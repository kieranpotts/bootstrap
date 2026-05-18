#!/bin/bash

#
# Install the tmux multiplexer.
#
# https://github.com/tmux/tmux
#

startNewTask "Install tmux"

superdo apt install -y tmux
