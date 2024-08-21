#!/bin/bash

# ==============================================================================
# Helper functions for the bootstrap scripts.
# ==============================================================================

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
