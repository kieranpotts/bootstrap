#!/bin/bash

#
# Install unzip.
#
# Unzip is required for installation of other packages, such as
# oh-my-posh.
#

startNewTask "Installing unzip"

superdo apt-get install -y unzip

unzip -v
