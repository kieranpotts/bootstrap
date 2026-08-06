#!/usr/bin/env bash

#
# Install ROCm (AMD's open-source GPU computing platform) utilities.
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing ROCm utilities."

# ROCm System Management Interface.
superdo apt-get install rocm-smi -y
