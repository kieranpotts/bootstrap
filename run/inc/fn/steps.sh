#!/usr/bin/env bash

#
# Utility functions to announce discrete steps in the bootstrap process,
# and to run each step in an isolated subshell so that a single failure
# does not abort the entire bootstrap.
#

# Global step counter. Backed by a temp file so that increments survive across
# the subshells used by `step()`. Without the file backing, `print_step`
# inside a subshell would only increment a local copy.

export STEP=0
STEP_FILE=$(mktemp)
echo 0 > "${STEP_FILE}"
export STEP_FILE

# List of steps that failed. Mutated by `step()` in the parent shell only.
declare -a FAILED_STEPS=()

# print_starting - Announce the start of the bootstrap script.
#
print_starting() {

  local out
  out=$(cat <<EOF
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ STARTING                                                                     ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
EOF
)

  echo "${out}"
}

# print_updating - Announce the start of an update pass (`run/update`).
#
print_updating() {

  local out
  out=$(cat <<EOF
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ UPDATING                                                                     ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
EOF
)

  echo "${out}"
}

# step - Run a bootstrap step in an isolated subshell.
#
# Sources the given file inside `( set -e; source FILE )`, so that:
#   - Internal command failures within the step still abort the step
#     (via errexit inside the subshell).
#   - `exit N` within the step terminates only the subshell, not the parent
#     bootstrap — the failure is logged and the next step runs.
#
# Functions and variables defined in the parent shell (print_*, superdo,
# is_gui_enabled, ${bashrc}, ${inc_path}, etc.) are inherited automatically.
# State changes made inside the step (variable mutations, `cd`) do NOT
# propagate back to the parent — by design.
#
# Arguments:
#   $1 - Absolute path to the step file to source.
#
step() {
  local file="$1"

  # Disable errexit in the parent while the subshell runs, so a non-zero
  # exit from the subshell does not abort the bootstrap.
  set +e

  # shellcheck disable=SC1090
  ( set -e; source "${file}" )
  local rc=$?
  set -e

  if [[ "${rc}" -ne 0 ]]; then
    FAILED_STEPS+=("${file} (exit ${rc})")
    print_warning "Step ${file} failed (exit ${rc}). Continuing."
  fi
}

# core_step - Run a step that belongs in every profile, including "agent".
#
# A thin wrapper around `step()`, used at the call site in
# `run/inc/fn/install-steps.sh` to mark a step as core: useful to a coding
# agent working unattended inside a minimal container, as well as on a full
# workstation. Core steps always run, unprompted, in both profiles.
#
# This exists as a distinct name (rather than calling `step` directly) so
# that "what's in the agent profile" is answered by grep'ing for
# `core_step` calls in one file, instead of being scattered across guards
# inside dozens of step files. See `docs/tools.md` for the resulting table.
#
# Arguments:
#   $1 - Absolute path to the step file to source.
#
core_step() {
  step "$1"
}

# confirm_step - Prompt for confirmation, then run a step via `step()`.
#
# Used for "one tool per script" steps (the app/*, dev/*, ops/*, phy/*, and
# web/* categories in `run/inc/fn/install-steps.sh`) so the user can skip an
# individual application or tool without editing the script. Declining skips
# the step entirely: the underlying file is never sourced, its own
# `print_step` banner never prints, and the skip does not count as a failure
# in `FAILED_STEPS`.
#
# Under the "agent" profile (`--profile=agent`, see `is_agent_profile`),
# every `confirm_step` is skipped outright — no prompt, no fallback to
# yes/no defaults. The agent profile installs only `core_step` steps (plus
# the always-on `sys/*`/`util/*`/`pkg/*` plumbing); confirm_step exists for
# exactly the tools a workstation user might want but a headless agent
# container has no use for.
#
# Otherwise, the prompt defaults to yes — pressing Enter, or any reply other
# than `n`/`N`, runs the step. The prompt itself is skipped, and the step
# always runs, when there is nothing to usefully prompt:
#
#   - `--yes`/`-y` was passed (`is_yes_enabled`).
#   - stdin is not a terminal (piped output, `docker build`, CI) — mirrors
#     the no-TTY fallback in `sys/checks.sh`, so unattended/logged runs
#     (eg. `./run/install > install.log 2>&1`) still install everything.
#
# Arguments:
#   $1 - Absolute path to the step file to source.
#   $2 - Human-readable name of the application/tool, for the prompt text.
#
confirm_step() {
  local file="$1"
  local name="$2"

  if is_agent_profile; then
    print_info "Skipping ${name} (not part of the agent profile)."
    return 0
  fi

  if ! is_yes_enabled && [[ -t 0 ]]; then
    read -r -p "Install/update ${name}? (Y/n): " -n 1 -r
    echo
    if [[ "${REPLY}" =~ ^[Nn]$ ]]; then
      print_info "Skipping ${name}."
      return 0
    fi
  fi

  step "${file}"
}

# print_step - Print a message announcing the start of a new step.
#
# Arguments:
#   $1 - Message to print.
#
print_step() {

  # Read-modify-write the step counter via STEP_FILE so increments survive
  # across the subshells used by `step()`.
  if [[ -n "${STEP_FILE:-}" ]] && [[ -f "${STEP_FILE}" ]]; then
    STEP=$(cat "${STEP_FILE}")
    STEP=$((STEP + 1))
    echo "${STEP}" > "${STEP_FILE}"
  else
    STEP=$((STEP + 1))
  fi

  local msg="${STEP}. ${1}"

  local pad=$(( 77 - ${#msg} ))
  (( pad < 0 )) && pad=0

  # Message to render.
  local out
  out=$(cat <<EOF
┌──────────────────────────────────────────────────────────────────────────────┐
│ ${msg}$(printf '%*s' "${pad}" '')│
└──────────────────────────────────────────────────────────────────────────────┘
EOF
)

  # Print the message and give the user a moment to read it.
  echo "${out}"
  sleep 1
}

# print_finished - Announce the completion of the bootstrap script.
#
print_finished() {

  local out
  out=$(cat <<EOF
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ FINISHED                                                                     ┃
┃                                                                              ┃
┃ If this is the first time you have run this script, you may need to log out  ┃
┃ and back in to apply some of the changes. To do this, run the following      ┃
┃ command, and enter your password when prompted:                              ┃
┃                                                                              ┃
┃     su - \${USER}                                                             ┃
┃                                                                              ┃
┃ You should periodically re-sync the development environment repository, and  ┃
┃ re-run the bootstrap script, to keep your host system up-to-date.            ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
EOF
)

  echo "${out}"
}

# print_updated - Announce the completion of an update pass (`run/update`).
#
print_updated() {

  local out
  out=$(cat <<EOF
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ UPDATED                                                                      ┃
┃                                                                              ┃
┃ You should periodically re-sync the development environment repository, and  ┃
┃ re-run this script, to keep your host system up-to-date.                     ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
EOF
)

  echo "${out}"
}

# print_failures - Print a summary of any steps that failed.
#
# Prints nothing if `FAILED_STEPS` is empty. Otherwise prints a list of failed
# step file paths and their exit codes.
#
print_failures() {
  if (( ${#FAILED_STEPS[@]} == 0 )); then
    return 0
  fi

  echo ""
  print_warning "${#FAILED_STEPS[@]} step(s) failed during this bootstrap:"
  local failure
  for failure in "${FAILED_STEPS[@]}"; do
    echo "  - ${failure}"
  done

  print_info "Re-run the bootstrap to retry failed steps. Individual step failures do not block other steps from running."
}
