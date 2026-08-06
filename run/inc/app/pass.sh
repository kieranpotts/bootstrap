#!/usr/bin/env bash

#
# Install `pass`, a widely-used password manager for Unix systems. Can also
# back Docker's credential store via `docker-credential-pass`, for storing
# registry logins used by the native Docker engine.
#
# https://www.passwordstore.org/
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing pass."

print_info "Installing/updating pass via APT."
superdo apt-get install -y pass
