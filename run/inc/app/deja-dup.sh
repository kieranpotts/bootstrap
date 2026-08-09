#!/usr/bin/env bash

#
# Install Déjà Dup Backups.
#
# https://flathub.org/en/apps/org.gnome.DejaDup
#

print_step "Installing Déjà Dup Backups."

# DEPRECATED: Not using flatpak at the moment, because flatpak apps use the
# `xdg-desktop-portal` background daemon to do things like schedule backups.
# This is not available on the COSMIC desktop at the moment, so Flatpak apps
# running on COSMIC cannot yet register themselves to run automatically in the
# background.
# flatpak install flathub org.gnome.DejaDup -y

# Installing .deb package instead.
print_info "Installing/updating Déjà Dup Backups via APT."
superdo apt-get install -y deja-dup
