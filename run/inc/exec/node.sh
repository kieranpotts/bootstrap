#!/usr/bin/env bash

#
# Install Node using NVM - the Node Version Manager.
#
# https://nodejs.org/en
# https://github.com/nvm-sh/nvm
# https://learn.microsoft.com/en-us/windows/dev-environment/javascript/nodejs-on-wsl
#

print_step "Installing Node.js via NVM."

# If NVM is already installed, ensure it is available in the PATH for
# non-interactive shells. This is required for the line that evaluates the
# `nvm --version` command to capture the currently-installed version.

if [[ -s "${HOME}/.nvm/nvm.sh" ]]; then
  . "${HOME}/.nvm/nvm.sh"
fi

# Target NVM version we want to install (strip leading `v` from the tag).

latest_version=$(gh_latest_tag nvm-sh/nvm | sed 's/^v//')
print_info "Latest available version of NVM is v${latest_version}."

# Discover the installed version of NVM, if it exists.
installed_version=""
if command -v nvm >/dev/null 2>&1; then
  installed_version=$(nvm --version)
fi

# Check if NVM is already installed.
if [[ -d "${HOME}/.nvm" ]] && [[ -s "${HOME}/.nvm/nvm.sh" ]]; then

  if [[ "${installed_version}" == "${latest_version}" ]]; then
    print_info "Latest version of NVM, v${latest_version}, is already installed. Skipping."
  else
    print_info "Updating NVM from v${installed_version} to v${latest_version}."

    # Remember the current working directory,
    # so we can change back here later.
    cwd=$(pwd)

    # Update to the target version
    cd ~/.nvm || true
    git fetch --tags origin
    git checkout "v${latest_version}"

    # Re-source the updated `nvm.sh` file.
    . ./nvm.sh

    # Change back to the original directory
    cd "${cwd}" || true

    print_success "Updated NVM to version v${latest_version}."
  fi

else

  print_info "NVM not installed, proceeding with fresh installation."

  # Remember the current working directory, so we can change back here later.
  cwd=$(pwd)

  # Installation script based on the Git-install method documented here:
  # https://github.com/nvm-sh/nvm?tab=readme-ov-file#git-install
  cd ~/ || true
  rm -Rf .nvm
  git clone https://github.com/nvm-sh/nvm.git .nvm

  cd ~/.nvm || true
  git checkout "v${latest_version}"

  # Source `nvm.sh` to load NVM immediately into the current shell session. This
  # is also required to make `npm` etc. available in the current shell session -
  # tools which may be required for subsequent steps in the bootstrap process.
  . ./nvm.sh

  # Change back to the original directory.
  cd "${cwd}" || true

  print_success "Installed NVM version v${latest_version}."

fi

# Add to .bashrc to automatically load NVM when a new shell session is started.
# Avoid duplication by checking for the presence of the export statement.
# Always run this - on every bootstrap run - to restore this to the user's
# .bashrc file, in case it was removed or modified.

print_info "Configuring ~/.bashrc to load NVM shell startup."

# Expressions not intended to be expanded.
# shellcheck disable=SC2016
content='
export NVM_DIR="${HOME}/.nvm"
[[ -s "${NVM_DIR}/nvm.sh" ]] && \. "${NVM_DIR}/nvm.sh" # Loads NVM
[[ -s "${NVM_DIR}/bash_completion" ]] && \. "${NVM_DIR}/bash_completion" # Loads Bash completion for NVM
'

# shellcheck disable=SC2154
if [[ -f "${bashrc}" ]]; then
  if ! grep -q "export NVM_DIR" "${bashrc}"; then
    echo "${content}" >> "${bashrc}"
  fi
fi

# Use NVM to install the current LTS version of Node, plus previous LTS versions
# of Node that are not yet at end-of-life. For each major LTS release, we
# install the first minor/patch version to receive the LTS label, rather than
# the most recent version in that major line. See the links for each release's
# changelog to find the first version number for each major LTS release.
#
# https://nodejs.org/en/about/previous-releases

# https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V22.md
if ! nvm list | grep -q "v22.11.0"; then
  print_info "Installing Node.js LTS v22.11.0."
  nvm install 22.11.0
else
  print_info "Node.js LTS v22.11.0 is already installed."
fi

# https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V20.md
if ! nvm list | grep -q "v20.9.0"; then
  print_info "Installing Node.js LTS v20.9.0."
  nvm install 20.9.0
else
  print_info "Node.js LTS v20.9.0 is already installed."
fi

# DEPRECATED:
# Prior LTS versions - now EOL:

# https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V18.md
# nvm install 18.12.0

# https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V16.md
# nvm install 16.13.0

# https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V14.md
# nvm install 14.15.0

# https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V12.md
# nvm install 12.13.0

# https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V10.md
# nvm install 10.13.0

# Use the current active LTS version as the default.
print_info "Setting Node.js LTS v22.11.0 as the current version."
nvm use 22.11.0
