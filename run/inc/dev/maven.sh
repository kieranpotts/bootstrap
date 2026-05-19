#!/usr/bin/env bash

#
# Installs Maven.
#
# https://maven.apache.org/
#

print_step "Install Maven"

superdo apt-get install -y maven

mvn --version
