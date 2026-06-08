#!/usr/bin/env bash

#
# Predicates for detecting the host operating system.
#

# is_ubuntu_family - Test whether the host is Ubuntu or an Ubuntu derivative.
#
# Reads ID / ID_LIKE from /etc/os-release. True for Ubuntu itself and for
# derivatives that declare `ID_LIKE=...ubuntu...` (eg. Pop!_OS, Linux Mint).
#
# Use this to gate steps that depend on Ubuntu-only infrastructure such as
# Launchpad PPAs (`add-apt-repository ppa:...`), which crash on plain Debian
# (eg. the debian:bookworm-slim base image) with:
#   AttributeError: 'NoneType' object has no attribute 'people'
#
#   is_ubuntu_family || return 0
#
# Returns:
#   0 if the host is in the Ubuntu family, 1 otherwise (including when
#   /etc/os-release is missing or unreadable).
#
is_ubuntu_family() {
  [[ -r /etc/os-release ]] || return 1

  # Source in a subshell so /etc/os-release's variables don't leak into the
  # caller's scope.
  local id id_like
  { read -r id; read -r id_like; } < <(
    . /etc/os-release
    printf '%s\n%s\n' "${ID:-}" "${ID_LIKE:-}"
  )

  [[ "${id}" == "ubuntu" || "${id_like}" == *ubuntu* ]]
}
