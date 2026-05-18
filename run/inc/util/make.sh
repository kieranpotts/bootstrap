#!/bin/bash

#
# Install Make.
#

startNewTask "Install Make"

superdo apt install -y make

make --version
