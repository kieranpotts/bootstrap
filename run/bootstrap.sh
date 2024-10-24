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

# Install general utilities.
source "${inc}/util/curl.sh"
source "${inc}/util/gnupg.sh"
#source "${inc}/util/mlocate.sh"
source "${inc}/util/software-properties-common.sh"

# Install dev tools.
source "${inc}/dev/chrome.sh"
source "${inc}/dev/delta.sh"
source "${inc}/dev/git.sh"
source "${inc}/dev/git-extras.sh"
source "${inc}/dev/git-lfs.sh"
source "${inc}/dev/lazygit.sh"
source "${inc}/dev/neovim.sh"
source "${inc}/dev/oh-my-posh.sh"
source "${inc}/dev/tmux.sh"

# Install ops tools.
source "${inc}/ops/aws.sh"
source "${inc}/ops/terraform.sh"

# Install runtime environments.
source "${inc}/run/node.sh"
source "${inc}/run/jdk.sh"
source "${inc}/run/php.sh"
source "${inc}/run/python.sh"

# Finalise.
source "${inc}/sys/teardown.sh"
source "${inc}/msg/finish.sh"
