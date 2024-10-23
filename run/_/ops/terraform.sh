#!/bin/bash

# ==============================================================================
# Install Terraform.
#
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
# ==============================================================================

startNewTask "Install Terraform"

# Install the HashiCorp GPG key.
# Requires gnugp.
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Verify the key's fingerprint.
gpg --no-default-keyring \
  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  --fingerprint

# Add the official HashiCorp repository to your system.
# The `lsb_release -cs` command finds the distribution release codename for
# your system, such as `buster`, `groovy`, or `sid`.
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# Download the package information from HashiCorp.
sudo apt update

# Install Terraform from the new repository.
sudo apt-get install terraform

# Verify the installation.
terraform -help

# Install the autocomplete package. This will not take effect until
# the shell is restarted (or ~/.bashrc is re-sourced).
terraform -install-autocomplete
