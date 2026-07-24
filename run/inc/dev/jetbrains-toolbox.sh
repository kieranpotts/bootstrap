#!/usr/bin/env bash

#
# Install the JetBrains Toolbox app, from which IntelliJ IDEA and other
# JetBrains products can be installed and managed.
#
# This script does not update the Toolbox app, it only installs it if it is not
# found on the system. The Toolbox app is auto-updating.
#
# https://www.jetbrains.com/help/idea/installation-guide.html#toolbox
#

is_gui_enabled || return 0

print_step "Installing JetBrains Toolbox."

# Configuration.
jetbrains_releases_api="https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release"
download_dir="/tmp/jetbrains-toolbox-install"
install_dir="${HOME}/.local/share/JetBrains/Toolbox"
install_binary="bin/jetbrains-toolbox"
desktop_entry_dir="${HOME}/.local/share/applications"

# Check if JetBrains Toolbox is already installed.
is_toolbox_installed() {
  if [[ -f "${install_dir}/${install_binary}" ]]; then
    return 0
  else
    return 1
  fi
}

if is_toolbox_installed; then
  print_info "JetBrains Toolbox is already installed. Skipping."
else

  print_info "Checking for required dependencies."

  required_packages="libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig1 libgtk-3-bin tar dbus-user-session"

  missing_packages=""

  for package in ${required_packages}; do
    if ! dpkg -l "${package}" >/dev/null 2>&1; then
      missing_packages="${missing_packages:+${missing_packages} }${package}"
    fi
  done

  if [[ -n "${missing_packages}" ]]; then
    print_info "Installing missing dependencies: ${missing_packages}"
    superdo apt-get update

    # Word splitting is intentional here: each package name is a separate argument.
    # shellcheck disable=SC2086
    superdo apt-get install -y ${missing_packages}
  else
    print_info "All required dependencies are already installed."
  fi

  # Remember the current working directory, so we can change back here later.
  cwd=$(pwd)

  print_info "Making temporary download directory for the JetBrains Toolbox app installer."
  mkdir -p "${download_dir}"
  cd "${download_dir}" || true

  print_info "Fetching latest JetBrains release info from the JetBrains releases API."
  release_info_json=$(curl -s "${jetbrains_releases_api}")

  # Extract download and checksum URLs from the JSON file, using jq.
  download_url=$(echo "${release_info_json}" | jq -r '.TBA[0].downloads.linux.link')
  checksum_url=$(echo "${release_info_json}" | jq -r '.TBA[0].downloads.linux.checksumLink')

  if [[ -z "${download_url}" ]] || [[ -z "${checksum_url}" ]]; then
    print_error "Failed to retrieve download or checksum URL for JetBrains Toolbox."
    exit 1
  fi

  print_info "Downloading the JetBrains Toolbox archive."
  download_filename="jetbrains-toolbox.tar.gz"
  if curl -L --progress-bar --fail "${download_url}" -o "${download_filename}"; then
    print_success "Download completed successfully."
  else
    print_error "Failed to download JetBrains Toolbox."
    exit 1
  fi

  print_info "Verifying the download."
  if [[ ! -f "${download_filename}" ]] || [[ ! -s "${download_filename}" ]]; then
    print_error "Downloaded file is empty or missing."
    exit 1
  fi
  if ! file "${download_filename}" | grep -q "gzip compressed"; then
    print_error "Downloaded file is not a valid gzip archive."
    exit 1
  fi

  curl -s "${checksum_url}" -o toolbox.sha256
  if [[ ! -f "toolbox.sha256" ]]; then
    print_error "Failed to download checksum file."
    exit 1
  fi

  expected_sum=$(cut -d ' ' -f1 toolbox.sha256)
  actual_sum=$(sha256sum "${download_filename}" | cut -d ' ' -f1)
  if [[ "${expected_sum}" != "${actual_sum}" ]]; then
    print_error "Checksum mismatch! Aborting installation."
    exit 1
  fi

  print_success "Download verified. Checksum matches."

  print_info "Extracting Toolbox application."
  tar -xzf "${download_filename}" -C "${download_dir}"

  # Find the extracted directory - it should be named "jetbrains-toolbox-<version>".
  extracted_dir=$(find . -maxdepth 1 -type d -name "jetbrains-toolbox-*")
  if [[ -z "${extracted_dir}" ]]; then
    print_error "Extraction failed."
    exit 1
  fi

  if [[ ! -f "${extracted_dir}/${install_binary}" ]]; then
    print_error "Could not find extracted JetBrains Toolbox installer. Cannot proceed."
    exit 1
  fi

  # Copy files to the installation directory.
  print_info "Installing JetBrains Toolbox to ${install_dir}."
  mkdir -p "${install_dir}"
  cp -r "${extracted_dir}"/* "${install_dir}/"

  # Make the Toolbox binary executable.
  chmod +x "${extracted_dir}/${install_binary}"

  print_info "Starting JetBrains Toolbox in the background."
  nohup "${install_dir}/${install_binary}" > /dev/null 2>&1 &

  print_success "JetBrains Toolbox installed."

  # Tidy up: move back to the original directory, then remove the temporary
  # directory and all its contents.
  cd "${cwd}" || true
  rm -rf "${download_dir}"

  # Add desktop entry.
  print_info "Creating desktop entry for JetBrains Toolbox."

  mkdir -p "${desktop_entry_dir}"
  desktop_file="${desktop_entry_dir}/jetbrains-toolbox.desktop"

  cat > "${desktop_file}" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=JetBrains Toolbox
Icon=${install_dir}/${install_binary}.png
Exec=${install_dir}/${install_binary}
Comment=JetBrains Toolbox App
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-toolbox
StartupNotify=true
EOF

  # Make the desktop entry executable.
  chmod +x "${desktop_file}"
  print_success "Desktop entry created for JetBrains toolbox."

  print_info "The JetBrains Toolbox app has been installed on your system."
  print_info "Launch it from your application menu and use it to install IntelliJ and other tools."

fi
