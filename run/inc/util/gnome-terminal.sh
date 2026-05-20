#!/usr/bin/env bash

#
# Install gnome-terminal.
#
# This is required for terminal access in Docker Desktop, but only if the host
# system is not itself using GNOME as its desktop environment.
#

print_step "Installing gnome-terminal."

print_info "Docker Desktop requires gnome-terminal if the host system is not using GNOME desktop."

if [[ "${XDG_CURRENT_DESKTOP}" != "GNOME" ]]; then
  print_info "Non-GNOME desktop detected. Installing gnome-terminal via APT."
  superdo apt-get install -y gnome-terminal
else
  print_info "GNOME desktop detected. Skipping gnome-terminal installation."
fi
