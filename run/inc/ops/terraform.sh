#!/usr/bin/env bash

#
# Install Terraform.
#
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
#

print_step "Installing Terraform."

print_info "Installing/updating Terraform via APT."
superdo apt-get install -y terraform

# Install the autocomplete package.
# This will error and exit if the autocomplete configuration is already
# installed - hence the "|| true" bit to allow the script to continue.

#terraform -install-autocomplete 2> /dev/null || true

# Better to just add the configuration directly to the user's bashrc file.
# This is all the `terraform -install-autocomplete` command does anyway, and
# this allows us to control where the configuration is added.

# shellcheck disable=SC2154
if [[ -f "${bashrc}" ]]; then
  if ! grep -q "/usr/bin/terraform" "${bashrc}"; then
    printf "%s\n" "complete -C /usr/bin/terraform terraform" >> "${bashrc}"
  fi
fi

print_success "Terraform installed successfully."
