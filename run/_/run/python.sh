#!/bin/bash

# ==============================================================================
# Install Python 3 and pip, and related tools.
# ==============================================================================

startNewTask "Install Python, pip, pipenv, etc."

sudo apt install -y python3 python3-pip ipython3

# https://pipenv.pypa.io/en/latest/
pip install --user pipenv

# Add ~/.local/bin to PATH, required for the virtualenv script which is
# installed here, see:
# https://pipenv.pypa.io/en/latest/installation.html#installing-pipenv
if [ -f "$HOME/local.bashrc" ]; then
  if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/local.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/local.bashrc"
  fi
elif [ -f "$HOME/.bashrc" ]; then
  if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  fi
fi
