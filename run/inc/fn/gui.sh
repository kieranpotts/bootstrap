#!/usr/bin/env bash

#
# Predicates for runtime feature toggles set by `run/bootstrap` and
# `run/update`.
#

# is_gui_enabled - Test whether GUI installs are enabled for the current run.
#
# Reads the `install_gui` flag set by `run/bootstrap` or `run/update` when
# parsing CLI args. Use this from any install step that should only run when
# `--gui` was passed:
#
#   is_gui_enabled || return 0
#   print_step "Installing <gui-thing>"
#   ...
#
# Returns:
#   0 if `--gui` was passed, 1 otherwise.
#
is_gui_enabled() {
  [[ "${install_gui:-0}" -eq 1 ]]
}

# is_updating - Test whether the current run is an update pass (`run/update`)
# rather than a first-time bootstrap (`run/bootstrap`).
#
# Reads the `updating` flag, set only by `run/update`. Use this from any
# install step that must not perform a first-time install on an update pass:
#
#   - Pure-APT steps with no extra config, already kept current by the
#     blanket `apt upgrade` in `sys/upgrade.sh`, should no-op entirely:
#
#       is_updating && return 0
#       print_step "Installing <apt-thing>"
#       ...
#
#   - Steps using a non-APT install mechanism (npm, curl, GitHub releases,
#     etc.) should only upgrade a tool that is already installed, never
#     install it for the first time:
#
#       print_step "Installing <thing>"
#       if is_updating && ! command -v <thing> >/dev/null 2>&1; then
#         return 0
#       fi
#       ...
#
# Returns:
#   0 if running under `run/update`, 1 otherwise (including `run/bootstrap`).
#
is_updating() {
  [[ "${updating:-0}" -eq 1 ]]
}
