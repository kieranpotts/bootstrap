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
