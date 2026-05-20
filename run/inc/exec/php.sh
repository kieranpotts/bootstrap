#!/usr/bin/env bash

#
# Install PHP, using phpenv as the version manager and php-build to compile
# multiple active versions of PHP.
#
# Building PHP from source is a brittle and slow process, but the trade-off is
# it allows multiple PHP versions to be installed alongside each other, with
# phpenv allowing easy toggling between versions.
#
# https://www.php.net/
# https://github.com/phpenv/phpenv
# https://github.com/php-build/php-build
#

print_step "Install PHP via phpenv."

# Remember the current working diectory,
# so we can change back here later.
cwd=$(pwd)

# Checkout phpenv into ~/.phpenv. Else update it.
if [ ! -d "$HOME/.phpenv" ]; then
  git clone https://github.com/phpenv/phpenv.git "$HOME/.phpenv"
else
  cd "$HOME/.phpenv" || true
  git pull
fi

# Move back to the original directory.
cd "${cwd}" || true

# Add phpenv binaries to PATH.
# shellcheck disable=SC2154
if [[ -f "${bashrc}" ]]; then
  if ! grep -q ".phpenv/bin" "${bashrc}"; then
    {
      echo 'export PATH="$HOME/.phpenv/bin:$PATH"'
      echo 'eval "$(phpenv init -)"'
    } >> "${bashrc}"
  fi
fi

# Re-source the shell startup scripts.
# This is equired to initialize phpenv immediately (`phpenv init -`).
# The rest of this script depends on `phpenv` being available.
if [ -f "$HOME/local.bashrc" ]; then
  . "$HOME/local.bashrc"
else
  touch "$HOME/.bashrc"
  . "$HOME/.bashrc"
fi

# Install php-build as a plugin. Clone on first run, pull on subsequent runs
# (a bare `git clone` aborts when the target directory already exists).
# https://github.com/php-build/php-build

php_build_dir="$(phpenv root)/plugins/php-build"
if [ ! -d "${php_build_dir}/.git" ]; then
  mkdir -p "${php_build_dir}"
  git clone https://github.com/php-build/php-build "${php_build_dir}"
else
  cd "${php_build_dir}" || true
  git pull
fi

# Also install php-build as a standalone binary. This is required
# to allow us to query the available PHP "definitions" (aka. versions).
cd "$(phpenv root)/plugins/php-build" || true
superdo ./install.sh

# Print list of available PHP "definitions" from the php-build repository.
print_info "Available PHP definitions:"
php-build --definitions

# Install php-dev, which will include the compiler needed to build PHP
# extensions such as Xdebug.
superdo apt-get install -y php-dev

# The following dependencies are required by php-build:
# https://php-build.github.io/
superdo apt-get install -y g++ libmcrypt-dev libreadline-dev

# The following packages have been found to be dependencies of the build step,
# which is handled by php-build when phpenv install is run.
superdo apt-get install -y \
  bzip2 \
  libbz2-dev \
  libcurl4-openssl-dev \
  libjpeg-dev \
  libonig-dev \
  libpng-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libtidy-dev \
  libxml2-dev \
  libxslt-dev \
  libzip-dev \
  pkg-config

# TODO: PHP versions require upgrade.
#
# Install the most recent definitions available for the current "active support"
# PHP versions as of 2024-08-22. See https://www.php.net/supported-versions.php
#
# The compilation steps take some time, so we skip any existing installs.
#
# The phpenv install commands may show warnings about a missing PHP_Archive
# PEAR package. This can be ignored - it does not break the build, see:
# https://github.com/php-build/php-build/issues/115

phpenv install --skip-existing 8.3.8
#phpenv install --skip-existing 8.2.20

# Show available versions - should match the above.
phpenv versions

# Set the global PHP version (ie the default for all shells). This can be
# overridden on a project-by-project basis using `phpenv local`.
phpenv global 8.3.8

# Show the current PHP version.
phpenv version

# This commands shows you which binary is run when `php` is called.
phpenv which php

# Move back to the original directory.
cd "${cwd}" || true
