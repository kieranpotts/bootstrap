#!/bin/bash

# ==============================================================================
# Install wget.
# ==============================================================================

startNewTask "Install wget"

superdo apt install -y wget

wget --version
