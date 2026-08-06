#!/usr/bin/env bash

#
# Install Python 3 and pip, and related tools.
#

print_step "Installing Python 3 and pipx, and related tools."

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
if ! is_updating; then
  print_info "Installing python3, pip, pipx, venv, and ipython3."
  superdo apt-get install -y python3 pipx ipython3 python3-pip python3-venv
fi

# The Poetry installer and pipx place executables in ~/.local/bin, which is not on
# PATH in a non-interactive shell (eg. a `docker build` layer). Add it so the
# presence checks and version checks below — and the rest of this run — can
# find them (else `poetry` fails with exit 127, "poetry: command not found").
export PATH="${HOME}/.local/bin:${PATH}"

# https://pipenv.pypa.io/en/latest/
# Never a first install on `./run/update` — only upgrade what's present.
if ! is_updating || command -v pipenv >/dev/null 2>&1; then
  print_info "Installing/updating pipenv via pipx."
  pipx install pipenv
fi

# Poetry - https://python-poetry.org/docs/
# Never a first install on `./run/update` — only upgrade what's present.
if ! is_updating || command -v poetry >/dev/null 2>&1; then
  print_info "Installing/updating Poetry via official installer script."
  curl -sSL https://install.python-poetry.org | python3 -
fi

python3 --version
pip --version
pipx --version
command -v poetry >/dev/null 2>&1 && poetry --version
