#!/bin/bash

#
# Installs Maven.
#
# https://maven.apache.org/
#

startNewTask "Install Maven"

superdo apt install -y maven
