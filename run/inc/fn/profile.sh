#!/usr/bin/env bash

#
# The install profile, and the other runtime toggles set by `run/install`
# and `run/update` when parsing CLI arguments.
#
# The profile answers "who is driving this machine?":
#
#   agent   Nobody. A headless container running coding agents.
#   tui     A human at a terminal, with no display. The default.
#   gui     A human at a desktop.
#
# The profiles are cumulative - agent ⊆ tui ⊆ gui - so `gui` installs
# everything and `agent` installs the least. Note that the name describes the
# *environment*, not the shape of the tools: the `tui` profile contains plenty
# of non-interactive CLIs (`aws`, `ffmpeg`, `terraform`), and what it really
# means is "a human is present, but there is no display".
#
# Profile membership is declared at the call site in
# `run/inc/fn/install-steps.sh` (`agent_step`, `tui_step`, `gui_step`), never
# inside an install step. Install steps therefore have no reason to test the
# predicates below: "what does profile X install?" is answered by reading one
# file. See `docs/tools.md` for the resulting table.
#

# profile_rank - Print the numeric rank of a profile name, low to high.
#
# Used by `profile_at_least` to compare the requested profile against the one
# a step requires. An unrecognised name ranks below every real profile, so it
# satisfies nothing - `run/install` and `run/update` reject unknown profiles at
# parse time, so this is a backstop, not the primary validation.
#
# Arguments:
#   $1 - Profile name.
#
# Output:
#   The rank: 0 for `agent`, 1 for `tui`, 2 for `gui`, -1 for anything else.
#
profile_rank() {
  case "$1" in
    agent) echo 0 ;;
    tui) echo 1 ;;
    gui) echo 2 ;;
    *) echo -1 ;;
  esac
}

# profile_at_least - Test whether the current profile includes the given one.
#
# Reads the `profile` variable set by `run/install` or `run/update`, defaulting
# to `tui` to match those scripts.
#
# Arguments:
#   $1 - Minimum profile required, eg. `tui`.
#
# Returns:
#   0 if the current profile is the given one or higher, 1 otherwise.
#
profile_at_least() {
  local required current
  required=$(profile_rank "$1")
  current=$(profile_rank "${profile:-tui}")

  [[ "${current}" -ge "${required}" ]]
}

# is_agent_profile - Test whether the run is scoped to the `agent` profile.
#
# Provided for the rare step that must know it is provisioning a headless
# container - eg. to skip a check that can only pass on real hardware. Prefer
# expressing membership at the call site: an install step that is not in the
# agent profile is simply not called with `agent_step`.
#
# Returns:
#   0 if `--profile=agent` was passed, 1 otherwise.
#
is_agent_profile() {
  [[ "${profile:-tui}" == "agent" ]]
}

# is_updating - Test whether the current run is an update pass (`run/update`)
# rather than a first-time bootstrap (`run/install`).
#
# Reads the `updating` flag, set only by `run/update`. Use this from any
# install step that must not perform a first-time install on an update pass:
#
#   - Pure-APT steps with no extra config, already kept current by the
#     blanket `apt upgrade` in `sys/upgrade.sh`, should no-op entirely:
#
#       is_updating && return 0
#       print_step "Installing <apt-thing>."
#       ...
#
#   - Steps using a non-APT install mechanism (npm, curl, GitHub releases,
#     etc.) should only upgrade a tool that is already installed, never
#     install it for the first time:
#
#       print_step "Installing <thing>."
#       if is_updating && ! command -v <thing> >/dev/null 2>&1; then
#         return 0
#       fi
#       ...
#
# Returns:
#   0 if running under `run/update`, 1 otherwise (including `run/install`).
#
is_updating() {
  [[ "${updating:-0}" -eq 1 ]]
}

# is_yes_enabled - Test whether prompts are pre-answered "yes" for the
# current run.
#
# Reads the `assume_yes` flag set by `run/install` or `run/update` when
# parsing CLI args (`--yes`/`-y`). Consumed by the step wrappers in
# `run/inc/fn/steps.sh` to skip their per-tool confirmation prompt and run the
# step unconditionally. Individual install steps don't need to check it.
#
# Returns:
#   0 if `--yes`/`-y` was passed, 1 otherwise.
#
is_yes_enabled() {
  [[ "${assume_yes:-0}" -eq 1 ]]
}
