#!/bin/bash

#
# Predicates for runtime feature toggles set by `run/bootstrap`.
#

# is_gui_enabled - Test whether GUI installs are enabled for the current run.
#
# Reads the `install_gui` flag set by `run/bootstrap` when parsing CLI args.
# Use this from any install step that should only run when `--gui` was passed:
#
#   is_gui_enabled || return 0
#   print_step "Installing <gui-thing>"
#   ...
#
# Returns:
#   0 if `--gui` was passed, 1 otherwise.
#
is_gui_enabled() {
  [ "${install_gui:-0}" -eq 1 ]
}
