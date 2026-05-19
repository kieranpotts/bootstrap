#!/usr/bin/env bash

#
# Install Python 3 and pip, and related tools.
#

print_step "Installing Python 3 and pipx, and related tools."

print_info "Installing python3, pip, pipx, venv, and ipython3."
superdo apt-get install -y python3 pipx ipython3 python3-pip python3-venv

# https://pipenv.pypa.io/en/latest/
print_info "Installing pipenv via pipx."
pipx install pipenv

# Poetry - https://python-poetry.org/docs/
print_info "Installing Poetry via official installer script."
curl -sSL https://install.python-poetry.org | python3 -

python3 --version
pipx --version
poetry --version
