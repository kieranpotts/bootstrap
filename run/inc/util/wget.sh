#!/bin/bash

#
# Install wget.
#

startNewTask "Install wget"

superdo apt-get install -y wget

wget --version
