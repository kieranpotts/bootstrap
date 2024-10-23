#!/bin/bash

# ==============================================================================
# Install software-properties-common.
#
# This package provides an abstraction of the used APT repositories, allowing
# easy management (adding and removing) of PPAs. Without this package, PPAs and
# other package repositories would need to be manually added and removed in
# the `/etc/apt/sources.list` file or subsidiary files in the directory
# `/etc/apt/sources.list.d`.
#
# This package is often a requirement of the installation scripts of
# software packages, eg. this is required for installation of Terraform.
# ==============================================================================

sudo apt-get install -y software-properties-common
