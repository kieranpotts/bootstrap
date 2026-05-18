#!/bin/bash

#
# Helper functions for the bootstrap scripts.
#

# ANSI escapes used by the `print_*` helpers below.
RESET='\033[0m'
BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'

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

# ------------------------------------------------------------------------------
# Print a general information message.
#
# @param  1 - Message to print.
#
# @return void
#
function print_info {

  printf '%b%b[INFO]%b %s\n' "${BOLD}" "${BLUE}" "${RESET}" "$1"

}

# ------------------------------------------------------------------------------
# Print notification of a successful operation.
#
# @param  1 - Message to print.
#
# @return void
#
function print_success {

  printf '%b%b[SUCCESS]%b %s\n' "${BOLD}" "${GREEN}" "${RESET}" "$1"

}

# ------------------------------------------------------------------------------
# Print a warning message.
#
# @param  1 - Message to print.
#
# @return void
#
function print_warning {

  printf '%b%b[WARNING]%b %s\n' "${BOLD}" "${YELLOW}" "${RESET}" "$1"

}

# ------------------------------------------------------------------------------
# Notify the user of an error.
#
# Usage of this function should be followed by an exit command, with a non-zero
# exit code to indicate failure.
#
# @param  1 - Message to print.
#
# @return void
#
function print_error {

  printf '%b%b[ERROR]%b %s\n' "${BOLD}" "${RED}" "${RESET}" "$1"

}
