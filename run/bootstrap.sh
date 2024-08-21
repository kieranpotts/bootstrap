#!/bin/bash

# ==============================================================================
# Dev VM bootstrap script.
# ==============================================================================

# Includes directory name.
inc="./run/_"

# Load helper functions.
source "${inc}/utils.sh"

# Print start message.
source "${inc}/msg/start.sh"

# Update and install system utilities.
source "${inc}/sys/update.sh"
source "${inc}/sys/upgrade.sh"

# Install dev tools.
source "${inc}/get/tmux.sh"

# Finalise.
source "${inc}/sys/teardown.sh"
source "${inc}/msg/finish.sh"
