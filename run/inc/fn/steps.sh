#!/usr/bin/env bash

#
# Utility functions to announce discrete steps in the bootstrap process.
#

# Global step counter.
export STEP=0

# print_starting - Announce the start of the bootstrap script.
#
print_starting() {

  out=$(cat <<EOF
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ STARTING                                                                     ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
EOF
)

  echo "${out}"
}

# print_step - Print a message announcing the start of a new step.
#
# Arguments:
#   $1 - Message to print.
#
print_step() {

  # Increment the global step counter.
  STEP=$((STEP + 1))

  msg="${STEP}. ${1}"

  local pad=$(( 77 - ${#msg} ))
  (( pad < 0 )) && pad=0

  # Message to render.
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
