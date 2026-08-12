#!/usr/bin/env bash

#
# Install psmisc.
#
# Provides `killall`, `fuser`, and `pstree`.
#
# Not present in `debian:bookworm-slim`, which is the base image for my
# devcontainers, so there is no way to kill a process by name across all its
# instances (`killall`), find what has a file or port open (`fuser`), or see
# the process tree (`pstree`). Complements `procps`, which provides `ps` and
# `pkill`/`pgrep` for the same "find and signal a process" workflow.
#
# https://gitlab.com/psmisc/psmisc
#

print_step "Installing psmisc."

print_info "Installing/updating psmisc via APT."
superdo apt-get install -y psmisc
