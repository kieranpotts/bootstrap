#!/bin/bash

# ==============================================================================
# Install PHP, using phpenv as the version manager and php-build to compile
# PHP in a way that multiple versions can be installed alongside each other.
#
# https://www.php.net/
# https://github.com/phpenv/phpenv
# https://github.com/php-build/php-build
# ==============================================================================

startNewTask "Install PHP via phpenv"

# Remember the current working diectory, so we can change back here later.
cwd=$(pwd)

# Checkout phpenv into ~/.phpenv. Else update it.
if [ ! -d "$HOME/.phpenv" ]; then
  git clone git@github.com:phpenv/phpenv.git "$HOME/.phpenv"
else
  cd "$HOME/.phpenv"
  git pull
fi

# Move back to the original directory.
cd ${cwd}

# Add shell startup scripts in an idempotent way.
if [ -f "$HOME/local.bashrc" ]; then
  if ! grep -q 'export PATH="$HOME/.phpenv/bin:$PATH"' "$HOME/local.bashrc"; then
    echo 'export PATH="$HOME/.phpenv/bin:$PATH"' >> "$HOME/local.bashrc"
    echo 'eval "$(phpenv init -)"' >> "$HOME/local.bashrc"
  fi
elif [ -f "$HOME/.bashrc" ]; then
  if ! grep -q 'export PATH="$HOME/.phpenv/bin:$PATH"' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.phpenv/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'eval "$(phpenv init -)"' >> "$HOME/.bashrc"
  fi
fi

# Install php-build as a plugin.
# https://github.com/php-build/php-build
mkdir -p $(phpenv root)/plugins/php-build
git clone https://github.com/php-build/php-build $(phpenv root)/plugins/php-build

# Also install php-build as a standalone binary. This is required
# to allow us to query the available PHP "definitions" (versions).
cd $(phpenv root)/plugins/php-build
sudo ./install.sh

# Use the following command to list all available PHP "definitions" from
# the php-build repository.
php-build --definitions

# The following dependencies are required by php-build:
# https://php-build.github.io/
sudo apt-get install -y g++ libmcrypt-dev libreadline-dev

# The following packages have been found to be dependencies of the build step,
# which is handled by php-build when phpenv install is run.
sudo apt install -y \
  libpng-dev \
  libjpeg-dev \
  libtidy-dev

# Install the most recent definitions available for the current "active support"
# PHP versions as of 2024-08-22. See https://www.php.net/supported-versions.php
# NOTE: The compilation steps take some time, so we skip any existing installs.
# NOTE: The phpenv install commands may show warnings about a missing PHP_Archive
# PEAR package; this can be ignored - it does not break the build, see:
# https://github.com/php-build/php-build/issues/115
phpenv install --skip-existing 8.3.8
phpenv install --skip-existing 8.2.20

# Re-source the shell startup scripts, to initialize phpenv now: `phpenv init -`.
if [ -f "$HOME/local.bashrc" ]; then
  source "$HOME/local.bashrc"
elif [ -f "$HOME/.bashrc" ]; then
  source "$HOME/.bashrc"
fi

# Show available versions - should match the above.
phpenv versions

# Set the global PHP version (ie the default for all shells). This can be
# overridden on a project-by-project basis using `phpenv local`.
phpenv global 8.3.8

# Show the current PHP version.
phpenv version

# This commands shows you which binary is run when `php` is called.
phpenv which php

# Optional - run a test script to check `php` is working.
#echo '<?php phpinfo(); ?>' > /tmp/phpinfo.php
#php /tmp/phpinfo.php

# Move back to the original directory.
cd ${cwd}
