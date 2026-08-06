#!/usr/bin/env bash

#
# Install Maven, a build automation tool for Java projects.
#
# https://maven.apache.org/
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing Maven."

print_info "Installing/updating Maven via APT."
superdo apt-get install -y maven
mvn --version
