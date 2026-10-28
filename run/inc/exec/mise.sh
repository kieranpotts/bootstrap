#!/usr/bin/env bash

#
# Install mise, the polyglot tool version manager.
#
# Projects pin their toolchains (Python, Poetry, ShellCheck, etc.) in a
# `mise.toml` file, so that the host and the devcontainer run the same tool
# versions.
#
# Depends on `pkg/mise.sh` to set up the package source in APT.
#
# https://mise.jdx.dev
# https://mise.jdx.dev/installing-mise.html#apt
# https://mise.jdx.dev/getting-started.html#activate-mise
#

print_step "Installing mise."

print_info "Installing/updating mise via APT."
superdo apt-get install -y mise

# Activate mise in interactive shells, so that the tools pinned by a project's
# `mise.toml` are on PATH whenever the shell is inside that project. Avoid
# duplication by checking for the presence of the activation line. Always run
# this - on every bootstrap run - to restore it to the user's bashrc file, in
# case it was removed or modified.
print_info "Configuring ~/.bashrc to activate mise on shell startup."

# Expressions not intended to be expanded.
# shellcheck disable=SC2016
content='
eval "$(mise activate bash)" # Activates mise
'

# shellcheck disable=SC2154
if [[ -f "${bashrc}" ]]; then
  if ! grep -q "mise activate bash" "${bashrc}"; then
    echo "${content}" >> "${bashrc}"
  fi
fi

mise --version
