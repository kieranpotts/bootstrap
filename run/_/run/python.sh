#!/bin/bash

# ==============================================================================
# Install Python 3 and pip, and related tools.
# ==============================================================================

# Single quotes are used in this file to prevent variable expansion.
# shellcheck disable=SC2016

startNewTask "Install Python, pip, pipenv, etc."

superdo apt install -y python3 python3-pip ipython3

# https://pipenv.pypa.io/en/latest/
pip install --user pipenv

# Poetry - https://python-poetry.org/docs/
curl -sSL https://install.python-poetry.org | python3 -

# Add ~/.local/bin to PATH, required for the virtualenv script which is
# installed here. See:
# https://pipenv.pypa.io/en/latest/installation.html#installing-pipenv
#
# I have this in my global.bashrc dotfiles by default, so look for it there
# first, before adding to local.bashrc. Fallback to  ~/.bashrc. See
#
if [ -f "$HOME/.bashrc" ] && grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
  : # Already configured in global.bashrc dotfiles, nothing to do.
elif [ -f "$HOME/local.bashrc" ] && ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/local.bashrc"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/local.bashrc"
  . "$HOME/local.bashrc"
else
  touch "$HOME/.bashrc"
  if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    . "$HOME/.bashrc"
  fi
fi

python3 --version
pip --version
poetry --version
