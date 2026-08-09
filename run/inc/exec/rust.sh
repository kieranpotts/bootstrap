#!/usr/bin/env bash

#
# Install Rust via Rustup, the official Rust toolchain installer.
#
# https://www.rust-lang.org/
# https://rustup.rs/
# https://doc.rust-lang.org/cargo/
#

print_step "Installing Rust via Rustup."

# Rustup installs binaries to ~/.cargo/bin, which is not on PATH in a
# non-interactive shell (eg. a `docker build` layer). Add it so the
# presence checks and version checks below — and the rest of this run —
# can find `cargo` and `rustc`.
export PATH="${HOME}/.cargo/bin:${PATH}"

if command -v rustup >/dev/null 2>&1; then
  print_info "Rustup is already installed. Updating the toolchain."
  rustup update
else
  print_info "Rustup is not installed. Proceeding with fresh installation."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Configure ~/.bashrc to source the Rustup env file, so `cargo`, `rustc`,
# and `rustup` are on PATH in interactive shells. The rustup installer
# appends this itself on a fresh install, but we add it here too — guarded
# with a `grep` check — so the line is restored if it was removed and so
# re-running the bootstrap does not duplicate it.
# shellcheck disable=SC2016
content='
# Source the Rustup env file to add ~/.cargo/bin to PATH.
[[ -s "${HOME}/.cargo/env" ]] && . "${HOME}/.cargo/env"
'

# shellcheck disable=SC2154
if [[ -f "${bashrc}" ]]; then
  if ! grep -q 'cargo/env' "${bashrc}"; then
    echo "${content}" >> "${bashrc}"
  fi

  # Re-source bashrc now, so `cargo` and `rustc` are immediately available
  # to subsequent steps in the bootstrap run.
  # shellcheck disable=SC1090
  . "${bashrc}"
fi

# Print the installed versions.
rustc --version
cargo --version
rustup --version
