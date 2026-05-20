#!/usr/bin/env bash

#
# Install skills-ref.
#
# skills-ref is a reference CLI for working with Agent Skills. It provides
# the `skills-ref` command, with subcommands to validate skill directories,
# read their properties, and generate XML prompts for agents.
#
# The tool is not published to PyPI, so it is installed directly from the
# `skills-ref` subdirectory of the agentskills GitHub repository, via pipx.
# The `--force` flag is used so that each run of the bootstrap script pulls
# the latest commit from the `main` branch.
#
# Requires Python 3.11 or newer, and is therefore only supported on
# Ubuntu 24.04 (whose default python3 is 3.12). On Ubuntu 22.04 the default
# python3 is 3.10, and this script will fail.
#
# https://github.com/agentskills/agentskills/tree/main/skills-ref
#

print_step "Installing skills-ref."

# Skip cleanly on systems where the default python3 is older than 3.11
# (eg. Ubuntu 22.04 ships 3.10), rather than failing later with a confusing
# `pipx` error.
python_version=$(python3 -c 'import sys; print(f"{sys.version_info[0]}.{sys.version_info[1]}")')
if ! python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 11) else 1)'; then
  print_warning "skills-ref requires Python 3.11+; detected ${python_version}. Skipping."
  return 0
fi

print_info "Installing/updating skills-ref via pipx."
pipx install --force \
  "git+https://github.com/agentskills/agentskills.git#subdirectory=skills-ref"

print_success "skills-ref installed successfully."
