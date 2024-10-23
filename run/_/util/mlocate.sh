#!/bin/bash

# ==============================================================================
# Install mlocate, which offers a fast database search of all files on the
# filesystem.
#
# https://pagure.io/mlocate
# ==============================================================================

startNewTask "Install mlocate"

# This is a very slow operation, the first time it is run, as a database
# is compiled of all files on the system. TODO: Investigate if this can be
# done on the background or otherwise deferred to a susequent manual step.
sudo apt install mlocate
