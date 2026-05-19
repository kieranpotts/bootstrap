#!/usr/bin/env bash

#
# Global configuration for the .bashrc file.
#

print_step "Configuring .bashrc."

# shellcheck disable=SC2154
if [[ -f "${bashrc}" ]]; then

  # Some applications, like pipenv and Cursor, require ~/.local/bin to be in
  # your PATH, and for it to take precedence over other paths.
  if ! (grep -q "/.local/bin:" "${bashrc}" || grep -q "/.local/bin:" "${HOME}/.bashrc"); then

    # shellcheck disable=SC2088
    print_info "~/.local/bin is not in your PATH. Adding it via ~/.bashrc."

    # shellcheck disable=SC2016
    {
      echo
      echo '# Add ~/.local/bin to PATH.'
      echo 'export PATH="${HOME}/.local/bin:${PATH}"'
    } >> "${bashrc}"

  fi

  print_info "Re-sourcing ~/.bashrc to pick up changes."
  . "${HOME}/.bashrc"
fi
