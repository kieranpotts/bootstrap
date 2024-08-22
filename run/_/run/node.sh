#!/bin/bash

# ==============================================================================
# Install Node using NVM - the Node Version Manager.
#
# https://nodejs.org/en
# https://github.com/nvm-sh/nvm
#
# https://learn.microsoft.com/en-us/windows/dev-environment/javascript/nodejs-on-wsl
# ==============================================================================

startNewTask "Install Node via NVM"

nvm_version="0.40.0"

# Rather than use the install script, we'll use the Git install method instead,
# so we have more control over how .bashrc is modified.
#wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/v${nvm_version}/install.sh" | bash

# Remember the current working diectory, so we can change back here later.
cwd=$(pwd)

# https://github.com/nvm-sh/nvm?tab=readme-ov-file#git-install
cd ~/
rm -Rf .nvm
git clone https://github.com/nvm-sh/nvm.git .nvm

cd ~/.nvm
git checkout "v${nvm_version}"

# Source nvm.sh to load NVM immediately into the current shell session.
. ./nvm.sh

# Define the content to be appended to the .bashrc file.
content='
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # Loads NVM
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # Loads Bash completion for NVM
'

# Add to .bashrc to automatically load NVM when a new shell session is started.
# Avoid duplication by checking for the presence of the export statement.
if [ -f "$HOME/local.bashrc" ]; then
  if ! grep -q "export NVM_DIR" "$HOME/local.bashrc"; then
    echo "$content" >> "$HOME/local.bashrc"
  fi
elif [ -f "$HOME/.bashrc" ]; then
  if ! grep -q "export NVM_DIR" "$HOME/.bashrc"; then
    echo "$content" >> "$HOME/.bashrc"
  fi
fi

# Move back to the original directory.
cd ${cwd}

# Use NVM to install the current LTS version of Node, plus the previous five
# LTS versions of Node - not the most recent LTS versions, but the very first
# minor/patch version to receive the LTS label in each major line.
# https://nodejs.org/en/about/previous-releases
nvm install 20.9.0    # github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V20.md
nvm install 18.12.0   # github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V18.md
nvm install 16.13.0   # github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V16.md
nvm install 14.15.0   # github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V14.md
nvm install 12.13.0   # github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V12.md
nvm install 10.13.0   # github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V10.md

# Use "active LTS" version as of 2024-08-21.
nvm use 18.12.0

# Print the versions of Node and NPM that are installed.
nvm --list
