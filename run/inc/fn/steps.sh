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
# Sources the given file inside `( set +u +o pipefail; set -e; source FILE )`,
# so that:
#   - Internal command failures within the step still abort the step
#     (via errexit inside the subshell).
#   - `exit N` within the step terminates only the subshell, not the parent
#     bootstrap — the failure is logged and the next step runs.
#   - The step runs under `set -e` only, not the entry point's full strict
#     mode. `-u` and `pipefail` are explicitly turned back off here, because
#     bash subshells otherwise inherit *every* option from the parent - a
#     bare `set -e` inside the subshell only reasserts errexit, it does not
#     undo `-u`/`pipefail`. Without this, an unset-var reference anywhere a
#     step touches (eg. sourcing the user's real `~/.bashrc`, which may
#     reference variables third-party tools never bothered to default) kills
#     the step, contrary to the documented intent in `run/install`.
#
# Also re-runs `npmrc_protect` (see `run/inc/fn/npmrc-protect.sh`) before
# every step, not just once at the start of the run — some npm-based CLI
# installers reintroduce the `~/.npmrc` setting it guards against midway
# through the step sequence, so the guard has to be re-checked before each
# step, not just before the first one.
#
# Functions and variables defined in the parent shell (print_*, superdo,
# ${bashrc}, ${inc_path}, etc.) are inherited automatically.
# State changes made inside the step (variable mutations, `cd`) do NOT
# propagate back to the parent — by design.
#
# Arguments:
#   $1 - Absolute path to the step file to source.
#
step() {
  local file="$1"

  npmrc_protect

  # Disable errexit in the parent while the subshell runs, so a non-zero
  # exit from the subshell does not abort the bootstrap.
  set +e

  # shellcheck disable=SC1090
  ( set +u +o pipefail; set -e; source "${file}" )
  local rc=$?
  set -e

  if [[ "${rc}" -ne 0 ]]; then
    FAILED_STEPS+=("${file} (exit ${rc})")
    print_warning "Step ${file} failed (exit ${rc}). Continuing."
  fi
}

# profile_step - Run a step if the current profile includes it.
#
# The shared implementation behind `cli_step`, `tui_step`, and `gui_step`.
# The step runs only when the requested profile is at least the one this
# call site requires (see `profile_at_least`). Filtering is silent: a step
# left out of the profile prints nothing, because the `## 💻 Programs` table
# in `README.md` already documents what each profile contains.
#
# Arguments:
#   $1 - Minimum profile this step belongs to (`cli`, `tui`, or `gui`).
#   $2 - Absolute path to the step file to source.
#
profile_step() {
  local required="$1"
  local file="$2"

  profile_at_least "${required}" || return 0

  step "${file}"
}

# cli_step - Run a step in every profile, including `cli`.
#
# The minimal tooling a coding agent needs to work unattended in a headless
# container, and which a human workstation wants too: these are the tools
# the bootstrap considers non-negotiable.
#
# Arguments:
#   $1 - Absolute path to the step file to source.
#
cli_step() {
  profile_step "cli" "$1"
}

# tui_step - Run a step in the `tui` and `gui` profiles.
#
# Tools that need a human present but no display. The default profile, and the
# right home for anything that is not clearly core to a headless container.
#
# Arguments:
#   $1 - Absolute path to the step file to source.
#
tui_step() {
  profile_step "tui" "$1"
}

# gui_step - Run a step in the `gui` profile only.
#
# Applications, browsers, and editors that need a display, plus the package
# registries that serve nothing else.
#
# Arguments:
#   $1 - Absolute path to the step file to source.
#
gui_step() {
  profile_step "gui" "$1"
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
