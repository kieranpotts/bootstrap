#!/usr/bin/env bash

#
# Installs Cursor CLI.
#
# Usage:
#   $ cursor-agent
#

print_step "Installing Cursor CLI."

print_info "Downloading and running official Cursor CLI installer script."
curl https://cursor.com/install -fsS | bash
