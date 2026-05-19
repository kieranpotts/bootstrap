#!/bin/bash

#
# Install Make.
#

startNewTask "Install Make"

superdo apt-get install -y make

make --version
