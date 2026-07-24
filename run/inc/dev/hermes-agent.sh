#!/usr/bin/env bash

#
# Installs Hermes Agent.
#
# https://hermes-agent.nousresearch.com/
#

print_step "Installing Hermes Agent."

# The `bash -s -- --skip-setup` pattern is the standard way to forward
# arguments to a piped install script. `-s` tells Bash to read from
# stdin, and `--` separates Bash's own flags from the arguments passed
# to the script. This bypasses the Hermes Agent setup wizard.

print_info "Downloading and running official Hermes Agent installer script."
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash -s -- --skip-setup
