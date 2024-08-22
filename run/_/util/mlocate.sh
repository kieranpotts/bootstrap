#!/bin/bash

# ==============================================================================
# Install mlocate, which offers a fast database search of all files on the
# filesystem.
#
# https://pagure.io/mlocate
# ==============================================================================

startNewTask "Install mlocate"

# This is a very slow operation, the first time it is run, as a database
# is compiled of all files on the system.
sudo apt install mlocate
