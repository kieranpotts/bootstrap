#!/usr/bin/env bash

#
# Installs gh-dash - a terminal UI dashboard for GitHub PRs and issues.
#
# Requires the GitHub CLI (`gh`), installed via `dev/gh.sh`.
#
# https://github.com/dlvhdr/gh-dash
# https://www.gh-dash.dev/getting-started
#

print_step "Installing gh-dash."

print_info "Installing/updating gh-dash as a gh CLI extension."
if gh extension list | grep -q "dlvhdr/gh-dash"; then
  gh extension upgrade dlvhdr/gh-dash
else
  gh extension install dlvhdr/gh-dash
fi

gh dash --version
