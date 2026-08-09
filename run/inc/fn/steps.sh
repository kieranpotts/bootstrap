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

# profile_step - Run a step if the current profile includes it, prompting
# first if the step is a discrete tool the user might want to skip.
#
# The shared implementation behind `agent_step`, `tui_step`, and `gui_step`.
# Two independent rules apply, and both are decided here rather than inside
# the step file:
#
#   - Profile. The step runs only when the requested profile is at least the
#     one this call site requires (see `profile_at_least`). Filtering is
#     silent: a step left out of the profile prints nothing, because
#     `docs/tools.md` already documents what each profile contains.
#
#   - Prompt. A step called *with* a display name is a discrete tool, and the
#     user is asked before it runs. A step called *without* one is bootstrap
#     plumbing (APT setup, package registries) and runs unannounced. The
#     prompt defaults to yes: pressing Enter, or any reply other than `n`/`N`,
#     runs the step.
#
# Declining a prompt skips the step entirely: the file is never sourced, its
# own `print_step` banner never prints, and the skip is not recorded as a
# failure in `FAILED_STEPS`.
#
# The prompt itself is skipped - and the step runs - when there is nothing to
# usefully prompt:
#
#   - `--yes`/`-y` was passed (`is_yes_enabled`).
#   - stdin is not a terminal (piped output, `docker build`, CI) — mirrors
#     the no-TTY fallback in `sys/checks.sh`, so unattended/logged runs
#     (eg. `./run/install > install.log 2>&1`) still install everything in
#     the requested profile.
#
# Arguments:
#   $1 - Minimum profile this step belongs to (`agent`, `tui`, or `gui`).
#   $2 - Absolute path to the step file to source.
#   $3 - Optional human-readable name of the tool, for the prompt text.
#        Omit for plumbing that should never prompt.
#
profile_step() {
  local required="$1"
  local file="$2"
  local name="${3:-}"

  profile_at_least "${required}" || return 0

  if [[ -n "${name}" ]] && ! is_yes_enabled && [[ -t 0 ]]; then
    read -r -p "Install/update ${name}? (Y/n): " -n 1 -r
    echo
    if [[ "${REPLY}" =~ ^[Nn]$ ]]; then
      print_info "Skipping ${name}."
      return 0
    fi
  fi

  step "${file}"
}

# agent_step - Run a step in every profile, including `agent`.
#
# The minimal tooling a coding agent needs to work unattended in a headless
# container, and which a human workstation wants too. Called without a display
# name, so it never prompts: these are the tools the bootstrap considers
# non-negotiable.
#
# Arguments:
#   $1 - Absolute path to the step file to source.
#   $2 - Optional display name. Rarely wanted; passing one makes a core tool
#        skippable at the prompt.
#
agent_step() {
  profile_step "agent" "$1" "${2:-}"
}

# tui_step - Run a step in the `tui` and `gui` profiles.
#
# Tools that need a human present but no display. The default profile, and the
# right home for anything that is not clearly core to a headless container.
#
# Arguments:
#   $1 - Absolute path to the step file to source.
#   $2 - Optional display name, for the prompt. Omit for plumbing.
#
tui_step() {
  profile_step "tui" "$1" "${2:-}"
}

# gui_step - Run a step in the `gui` profile only.
#
# Applications, browsers, and editors that need a display, plus the package
# registries that serve nothing else.
#
# Arguments:
#   $1 - Absolute path to the step file to source.
#   $2 - Optional display name, for the prompt. Omit for plumbing.
#
gui_step() {
  profile_step "gui" "$1" "${2:-}"
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
