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
source "${inc}/util/delta.sh"
source "${inc}/util/git.sh"
source "${inc}/util/git-extras.sh"
source "${inc}/util/git-lfs.sh"
source "${inc}/util/lazygit.sh"
source "${inc}/util/neovim.sh"
source "${inc}/util/oh-my-posh.sh"
source "${inc}/util/tmux.sh"


# Finalise.
source "${inc}/sys/teardown.sh"
source "${inc}/msg/finish.sh"
