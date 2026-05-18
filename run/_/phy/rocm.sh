#!/bin/bash

#
# Install ROCm (AMD's open-source GPU computing platform) utilities.
#

startNewTask "Installing ROCm utilities"

# ROCm System Management Interface.
sudo apt install rocm-smi -y
