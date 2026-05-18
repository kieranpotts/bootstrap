#!/bin/bash

#
# Helper functions for the bootstrap scripts.
#

# Global task counter.
i=0

# ------------------------------------------------------------------------------
# Print a message to inform the user a new task is about to getting
# started.
#
# @global i - Task incrementer.
# @param  1 - Message to print.
#
# @return void
#
function startNewTask {

  # Increment the global task counter.
  ((i++))

  # Message to render.
  read -r -d '' msg << EOF
────────────────────────────────────────────────────────────────────────────────
  STEP ${i}
  ${1}
────────────────────────────────────────────────────────────────────────────────
EOF

  # Print the message and give the user a moment to read it.
  echo "${msg}"
  sleep 2s

}

# ------------------------------------------------------------------------------
# Run a command with sudo if the current user is not root.
#
# If running as root (eg. in Docker), execute the command directly.
# Otherwise, prefix with sudo. This allows bootstrap scripts to work in both
# Docker (where they run as root during build) and on local systems under
# the current user.
#
# @param  * - Command and arguments to run.
#
# @return int - Exit code of the executed command.
#
function superdo {

  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi

}

# ------------------------------------------------------------------------------
# Test whether GUI installs are enabled for the current run.
#
# Reads the `install_gui` flag set by `run/bootstrap` when parsing CLI args.
# Use this from any install step that should only run when `--gui` was passed:
#
#   is_gui_enabled || return 0
#   startNewTask "Install <gui-thing>"
#   ...
#
# @global install_gui - Set by `run/bootstrap`.
#
# @return 0 if `--gui` was passed, 1 otherwise.
#
function is_gui_enabled {

  [ "${install_gui:-0}" -eq 1 ]

}
