#!/bin/bash

#
# Installs Claude Code.
#
# Requires Node.js and NPM.
#
# https://docs.anthropic.com/en/docs/claude-code/overview
#

startNewTask "Installing Claude Code via NPM"

# Requires Node.js v18 or newer.
npm install -g @anthropic-ai/claude-code
