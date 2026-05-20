#!/usr/bin/env bash

#
# Add GitHub's official package registry to APT.
#

print_step "Adding GitHub's official package registry."

# Add the GitHub CLI keyring.
superdo mkdir -p -m 755 /etc/apt/keyrings
wget -nv -O- https://cli.github.com/packages/githubcli-archive-keyring.gpg | superdo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
superdo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

# Add the GitHub CLI APT source.
superdo mkdir -p -m 755 /etc/apt/sources.list.d
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | superdo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

print_success "GitHub's package registry added to APT sources."
