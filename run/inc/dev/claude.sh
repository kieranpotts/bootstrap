#!/usr/bin/env bash

#
# Installs Claude Code.
#
# Requires Node.js v18 or newer.
#
# https://docs.anthropic.com/en/docs/claude-code/overview
#

print_step "Installing Claude Code."

print_info "Installing/updating Claude Code globally via NPM."
npm install -g @anthropic-ai/claude-code
claude --version
