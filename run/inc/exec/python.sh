#!/usr/bin/env bash

#
# Install Python 3 and pip, and related tools.
#

print_step "Installing Python 3 and pipx, and related tools."

print_info "Installing python3, pip, pipx, venv, and ipython3."
superdo apt-get install -y python3 pipx ipython3 python3-pip python3-venv

# The Poetry installer and pipx place executables in ~/.local/bin, which is not on
# PATH in a non-interactive shell (eg. a `docker build` layer). Add it so the
# presence checks and version checks below — and the rest of this run — can
# find them (else `poetry` fails with exit 127, "poetry: command not found").
export PATH="${HOME}/.local/bin:${PATH}"

# https://pipenv.pypa.io/en/latest/
print_info "Installing/updating pipenv via pipx."
pipx install pipenv

# Poetry - https://python-poetry.org/docs/
print_info "Installing/updating Poetry via official installer script."
curl -sSL https://install.python-poetry.org | python3 -

python3 --version
pip --version
pipx --version
command -v poetry >/dev/null 2>&1 && poetry --version
