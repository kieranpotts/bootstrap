#!/bin/bash

#
# Installs Maven.
#
# https://maven.apache.org/
#

startNewTask "Install Maven"

superdo apt-get install -y maven

mvn --version
