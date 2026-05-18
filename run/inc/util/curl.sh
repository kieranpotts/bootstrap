#!/bin/bash

#
# Install Curl
#

startNewTask "Installing curl"

superdo apt-get install -y curl

curl --version
