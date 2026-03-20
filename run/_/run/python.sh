#!/bin/bash

# ==============================================================================
# Install Python 3 and pip, and related tools.
# ==============================================================================

startNewTask "Install Python, pip, pipenv, etc."

superdo apt install -y python3 python3-pip ipython3

# https://pipenv.pypa.io/en/latest/
pip install --user pipenv

# Poetry - https://python-poetry.org/docs/
curl -sSL https://install.python-poetry.org | python3 -

# Add ~/.local/bin to PATH, required for the virtualenv script which is
# installed here, see:
# https://pipenv.pypa.io/en/latest/installation.html#installing-pipenv
if [ -f "$HOME/local.bashrc" ]; then
  # (Single quotes are used to prevent variable expansion.)
  # shellcheck disable=SC2016
  if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/local.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/local.bashrc"
    . "$HOME/local.bashrc"
  fi
else
  touch "$HOME/.bashrc"
  # (Single quotes are used to prevent variable expansion.)
  # shellcheck disable=SC2016
  if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    . "$HOME/.bashrc"
  fi
fi

python3 --version
pip --version
poetry --version
