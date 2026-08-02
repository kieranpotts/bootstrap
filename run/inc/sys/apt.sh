#!/usr/bin/env bash

#
# APT package manager setup and configuration.
#

print_step "Configuring APT."

print_info "Adding directory to store APT repository keys."
superdo install -d -m 0755 /etc/apt/keyrings

# Earlier versions of `pkg/microsoft.sh` wrote the Microsoft Edge registry to
# `microsoft-edge-stable.list`, while the `microsoft-edge-stable` package's own
# postinst script writes the same registry to `microsoft-edge.list`. Two sources
# for one URI with differing `Signed-By` values makes APT refuse to read *any*
# source list, breaking every step that follows. `pkg/microsoft.sh` now writes
# to Microsoft's own filename, so the stale file is only ever a leftover - but
# it has to be cleared here, before the first APT call, not when we get to
# `pkg/microsoft.sh`.
if [[ -f /etc/apt/sources.list.d/microsoft-edge-stable.list ]] \
  && [[ -f /etc/apt/sources.list.d/microsoft-edge.list ]]; then
  print_info "Removing conflicting Microsoft Edge APT source (superseded by microsoft-edge.list)."
  superdo rm -f /etc/apt/sources.list.d/microsoft-edge-stable.list
fi
