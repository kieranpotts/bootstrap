#!/bin/bash

# ==============================================================================
# Install OpenJDK using the Jabba JDK version manager.
#
# https://openjdk.org/
# https://github.com/openjdk/jdk
# https://github.com/shyiko/jabba
# ==============================================================================

startNewTask "Install OpenJDK via Jabba"

jabba_version="0.11.2"

export JABBA_VERSION=${jabba_version}
curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash -s -- --skip-rc && . ~/.jabba/jabba.sh

# Add scripts to .bashrc to automatically source jabba.sh at shell startup.
# Avoid duplication by checking for the presence of the export statement.
if [ -f "$HOME/local.bashrc" ]; then
  if ! grep -q "export JABBA_VERSION" "$HOME/local.bashrc"; then
    echo "export JABBA_VERSION=${jabba_version}" >> "$HOME/local.bashrc"
    echo "[ -s "$JABBA_HOME/jabba.sh" ] && . "$JABBA_HOME/jabba.sh"" >> "$HOME/local.bashrc"
  fi
elif [ -f "$HOME/.bashrc" ]; then
  if ! grep -q "export JABBA_VERSION" "$HOME/.bashrc"; then
    echo "export JABBA_VERSION=${jabba_version}" >> "$HOME/.bashrc"
    echo "[ -s "$JABBA_HOME/jabba.sh" ] && . "$JABBA_HOME/jabba.sh"" >> "$HOME/.bashrc"
  fi
fi

# Source jabba.sh to load Jabba immediately into the current shell session.
. ~/.jabba/jabba.sh

# Install the current LTS versions of OpenJDK, using direct downloads of the
# Eclipse Temurin builds from Adoptium. Follow the link below to generate the
# download URLs for the desired versions, and add the prefix (which will become
# the name of the version listed in `jabba ls`) as per the `jabba install`
# instructions, also linked below.
#
# Note, these commands are effectively idempotent. Jabba will not even download
# JDK tarballs if they are already installed.
#
# https://adoptium.net/en-GB/temurin/releases/?version=17&os=linux&arch=x64&package=jdk
# https://github.com/shyiko/jabba?tab=readme-ov-file#usage

# v21 LTS
jabba install 21.0.4+7=tgz+https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_x64_linux_hotspot_21.0.4_7.tar.gz

# v17 LTS
jabba install 17.0.12+7=tgz+https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.12%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.12_7.tar.gz

# v11 LTS
jabba install 11.0.24+8=tgz+https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.24%2B8/OpenJDK11U-jdk_x64_linux_hotspot_11.0.24_8.tar.gz

# v8 LTS
jabba install 8.0.422+5=tgz+https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u422-b05/OpenJDK8U-jdk_x64_linux_hotspot_8u422b05.tar.gz

# List all installed JDKs.
jabba ls

# Use v17 and make it the default JDK when starting a new shell session.
jabba use 17.0.12+7
jabba alias default 17.0.12+7

# Show current JDK version - the output of these two should show a matching version.
jabba current
java --version
