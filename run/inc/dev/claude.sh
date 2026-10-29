#!/usr/bin/env bash

#
# Installs Claude Code.
#
# Installs the native binary via the official install script. The launcher is
# placed at ~/.local/bin/claude, symlinked into ~/.local/share/claude/versions/.
# Native installations auto-update in the background, and re-running the
# install script converges on the latest version.
#
# Claude Code was previously installed as a global npm package. That is removed
# by `dev/claude-npm.sh`, via `./run/uninstall`.
#
# https://code.claude.com/docs/en/setup
#

print_step "Installing Claude Code."

print_info "Installing/updating Claude Code via official install shell script."
curl -fsSL https://claude.ai/install.sh | bash

# The native installer places the launcher in ~/.local/bin, which is added to
# .bashrc by sys/bashrc.sh, but install steps are run in non-interactive
# subshells that do not source .bashrc. So it is not yet on PATH here, and the
# version check below would fail.
export PATH="${HOME}/.local/bin:${PATH}"

claude --version
