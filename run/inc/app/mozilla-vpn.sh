#!/usr/bin/env bash

#
# Install Mozilla VPN directly from Mozilla's official repository, rather than
# the OS app store (such as Pop Shop on Pop OS) – see the configuration in
# ./repo/mozilla.sh.
#
# If Mozilla VPN has previously been installed via another source, it should be
# removed before running this bootstrap script: `sudo apt-get remove mozillavpn`.
# We have had issues with the Pop Shop version of Mozilla VPN, which appeared
# to be out-of-date (handshake issues suggested incompatibility with the VPN
# servers).
#

is_gui_enabled || return 0

print_step "Installing Mozilla VPN."

print_info "Installing Mozilla VPN via APT."
superdo apt-get install -y mozillavpn
