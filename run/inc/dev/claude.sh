#!/usr/bin/env bash

#
# Installs Claude Code.
#
# Requires Node.js and NPM.
#
# https://docs.anthropic.com/en/docs/claude-code/overview
#

print_step "Installing Claude Code."

# Requires Node.js v18 or newer.
print_info "Installing Claude Code globally via NPM."
npm install -g @anthropic-ai/claude-code
claude --version
