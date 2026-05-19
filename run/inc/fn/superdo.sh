#!/usr/bin/env bash

#
# Utility for running commands with elevated privileges.
#

# superdo - Run a command as root, with `sudo` only when needed.
#
# When the current user is already root (eg. during a Docker image build), the
# command is invoked directly. Otherwise it is prefixed with `sudo`. This lets
# the same install scripts run both as a regular user on a host machine and as
# root in a containerised build, without any branching at the call site.
#
# Arguments:
#   $@ - Command and arguments to run.
#
superdo() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}
