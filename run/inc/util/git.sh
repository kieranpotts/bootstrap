#!/bin/bash

#
# Install Git.
#

startNewTask "Install Git"

superdo apt-get install -y git

git --version
