#!/usr/bin/env bash

#
# Install Orca, GNOME's screen reader. It reads the desktop aloud via Speech
# Dispatcher, and can drive a re-freshable braille display, too.
#
# You can use Pied to customize the voice used for read-aloud.
#
# https://help.gnome.org/orca/index.html
# https://wiki.gnome.org/Projects/Orca
#

print_step "Installing Orca."

# Orca is packaged directly for Debian/Ubuntu, and its own dependencies pull
# in Speech Dispatcher and AT-SPI2, so no separate setup is needed. This also
# means it can immediately pick up any Piper voices Pied has installed via
# Speech Dispatcher.
superdo apt-get install -y orca

orca --version
