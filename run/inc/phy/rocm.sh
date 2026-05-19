#!/bin/bash

#
# Install ROCm (AMD's open-source GPU computing platform) utilities.
#

print_step "Installing ROCm utilities"

# ROCm System Management Interface.
sudo apt-get install rocm-smi -y

rocm-smi --version
