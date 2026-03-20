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
source "${inc}/util/git.sh"
source "${inc}/util/gnupg.sh"
source "${inc}/util/make.sh"
source "${inc}/util/software-properties-common.sh"
source "${inc}/util/unzip.sh"
source "${inc}/util/wget.sh"

# Install runtime environments.
source "${inc}/run/node.sh"
source "${inc}/run/jdk.sh"
source "${inc}/run/php.sh"
source "${inc}/run/python.sh"

# Install dev tools.
source "${inc}/dev/chrome.sh"
source "${inc}/dev/claude.sh"
source "${inc}/dev/copilot.sh"
source "${inc}/dev/delta.sh"
#source "${inc}/dev/git-extras.sh"
source "${inc}/dev/git-lfs.sh"
source "${inc}/dev/git-secret.sh"
source "${inc}/dev/lazygit.sh"
source "${inc}/dev/maven.sh"
source "${inc}/dev/neovim.sh"
source "${inc}/dev/oh-my-posh.sh"
source "${inc}/dev/shellcheck.sh"
source "${inc}/dev/tmux.sh"

# Install ops tools.
source "${inc}/ops/aws.sh"
source "${inc}/ops/terraform.sh"

# Finalize.
source "${inc}/sys/teardown.sh"
source "${inc}/msg/finish.sh"
