#!/usr/bin/env bash

#
# Install gnupg.
#
# The GNU Privacy Guard (GnuPG or GPG) is a complete and free implementation of
# the OpenPGP standard (also known as PGP) as defined by RFC4880.
#
# GnuPG allows you to encrypt and sign your data and communications.
#
# This package is often required for the installation of other software packages.
#
# https://gnupg.org/
#

print_step "Installing GNU Privacy Guard."

print_info "Installing/updating gnupg via APT."
superdo apt-get install -y gnupg
gpg --version

# Enable the GPG agent. This means you won't have to enter your passphrase
# every time you use your GPG key – which can get annoying when signing lots
# of Git commits, for instance.

mkdir -p "${HOME}/.gnupg"
touch "${HOME}/.gnupg/gpg.conf"

content=$(cat <<'EOF'
# Enable the GPG agent
use-agent
EOF
);

if ! grep -q "use-agent" "${HOME}/.gnupg/gpg.conf"; then
  printf "%s\n" "${content}" >> "${HOME}/.gnupg/gpg.conf"
fi

touch "${HOME}/.gnupg/gpg-agent.conf"

content=$(cat <<'EOF'
# Disable interaction with the GNOME keyring. This will remove the option to
# "save in password manager" your GPG keys' passphrases when you enter them
# in dialog prompts. (The Seahorse GUI application can be used to inspect
# login credentials, Wi-Fi passwords, etc. saved to the GNOME keyring.)
no-allow-external-cache

# Instead, configure the GnuGP Agent to cache your passphrases in memory,
# for a certain amount of time or until your machine is rebooted...

# Cache passphrases for 1 day (60 x 60 x 24 seconds).
default-cache-ttl 86400

# Maximum cache time regardless of use - also 1 day.
max-cache-ttl 86400

# But cache SSH keys for only 1 hour (max 2 hours) if using gpg-agent for SSH.
default-cache-ttl-ssh 3600
max-cache-ttl-ssh 7200
EOF
);

if ! grep -q "default-cache-ttl" "${HOME}/.gnupg/gpg-agent.conf"; then
  printf "%s\n" "${content}" >> "${HOME}/.gnupg/gpg-agent.conf"
fi

# shellcheck disable=SC2154
if [[ -f "${bashrc}" ]]; then
  if ! grep -q "export GPG_TTY" "${bashrc}"; then
    printf "%s\n" "export GPG_TTY=$(tty)" >> "${bashrc}"
  fi
  if ! grep -q "gpgconf" "${bashrc}"; then
    printf "%s\n" "gpgconf --launch gpg-agent" >> "${bashrc}"
  fi
fi
