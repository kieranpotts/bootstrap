#!/bin/bash

#
# Install the GitHub CLI (`gh`).
#
# https://github.com/cli/cli
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
#

startNewTask "Install GitHub CLI"

# Add the GitHub CLI keyring.
superdo mkdir -p -m 755 /etc/apt/keyrings
wget -nv -O- https://cli.github.com/packages/githubcli-archive-keyring.gpg | superdo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
superdo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

# Add the GitHub CLI apt source.
superdo mkdir -p -m 755 /etc/apt/sources.list.d
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | superdo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Install the GitHub CLI.
superdo apt-get update
superdo apt-get install gh -y
