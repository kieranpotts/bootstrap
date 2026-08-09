#!/usr/bin/env bash

#
# The install profile, and the other runtime toggles set by `run/install`
# when parsing CLI arguments.
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
# satisfies nothing - `run/install` rejects unknown profiles at parse time,
# so this is a backstop, not the primary validation.
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
# Reads the `profile` variable set by `run/install`, defaulting to `tui` to
# match that script.
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
