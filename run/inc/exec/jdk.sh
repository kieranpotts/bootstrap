#!/usr/bin/env bash

#
# Install OpenJDK using the Jabba JDK version manager.
#
# https://openjdk.org/
# https://github.com/openjdk/jdk
# https://github.com/shyiko/jabba
#

print_step "Installing OpenJDKs via Jabba."

# If Jabba is already installed, ensure it is available in the PATH for
# non-interactive shells. This is required for the line that evaluates the
# `jabba --version` command to capture the currently-installed version.
if [[ -s "${HOME}/.jabba/jabba.sh" ]]; then
  . "${HOME}/.jabba/jabba.sh"
fi

# Discover the installed version of Jabba, if it exists.
installed_version=""
if command -v jabba >/dev/null 2>&1; then
  installed_version=$(jabba --version)
fi

# Target Jabba version we want to install (Jabba's tags have no leading `v`).
latest_version=$(gh_latest_tag shyiko/jabba)
print_info "Latest available version of Jabba is v${latest_version}."

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "Jabba v${latest_version} is already installed. Skipping."
else

  if [[ "${installed_version}" == "" ]]; then
    print_info "Jabba is not currently installed. Will install Jabba v${latest_version} via GitHub release channel. "
  else
    print_info "Jabba v${installed_version} is installed. Will update to v${latest_version} via GitHub release channel."
  fi

  # Jabba's `install.sh` script uses this environment variable to determine the
  # version to install.
  export JABBA_VERSION=${latest_version}

  # Run the Jabba install script, which will download and install the target
  # Jabba version to ~/.jabba. Source the jabba.sh script to load Jabba into
  # the current shell session.
  # shellcheck disable=SC1090
  curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash -s -- --skip-rc && source ~/.jabba/jabba.sh

  print_success "Installed/updated Jabba to v${latest_version}."

fi

# Add scripts to .bashrc to automatically source `jabba.sh` at shell startup.
# Avoid duplication by checking for the presence of the export statement.

print_info "Configuring ~/.bashrc to source jabba.sh at shell startup."

# shellcheck disable=SC2154
if [[ -f "${bashrc}" ]]; then
  if ! grep -q "export JABBA_VERSION" "${bashrc}"; then

    # shellcheck disable=SC2016
    {
      echo
      echo "export JABBA_VERSION=${latest_version}"
      echo '[[ -s "${JABBA_HOME}/jabba.sh" ]] && . "${JABBA_HOME}/jabba.sh"'
    } >> "${bashrc}"

  fi
fi

# Install the current LTS versions of OpenJDK, using direct downloads of the
# Eclipse Temurin builds from Adoptium.
#
# Follow the link below to generate the download URLs for the desired versions,
# and add the prefix (which will become the name of the version listed in
# `jabba ls`) as per the `jabba install` instructions, also linked below.
#
# Note, these commands are effectively idempotent. Jabba will not even download
# JDK tarballs if they are already installed.
#
# https://adoptium.net/en-GB/temurin/releases/?version=17&os=linux&arch=x64&package=jdk
# https://github.com/shyiko/jabba?tab=readme-ov-file#usage

# v21 LTS
print_info "Jabba will install OpenJDK LTS v21 if not already installed."
jabba install 21.0.4+7=tgz+https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_x64_linux_hotspot_21.0.4_7.tar.gz

# v17 LTS
print_info "Jabba will install OpenJDK LTS v17 if not already installed."
jabba install 17.0.12+7=tgz+https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.12%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.12_7.tar.gz

# v11 LTS
#print_info "Jabba will install OpenJDK LTS v11 if not already installed."
#jabba install 11.0.24+8=tgz+https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.24%2B8/OpenJDK11U-jdk_x64_linux_hotspot_11.0.24_8.tar.gz

# v8 LTS
#print_info "Jabba will install OpenJDK LTS v8 if not already installed."
#jabba install 8.0.422+5=tgz+https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u422-b05/OpenJDK8U-jdk_x64_linux_hotspot_8u422b05.tar.gz

# List all installed JDKs.
print_success "The following OpenJDK LTS versions are installed:"
jabba ls

# Use v21 and make it the default JDK when starting a new shell session.
print_info "Setting OpenJDK v21 as the default JDK."
jabba use 21.0.4+7
jabba alias default 21.0.4+7

# Show current JDK version - the output of these two should show a matching version.
print_info "Currently using the following Java version:"
jabba current
java --version
