#!/usr/bin/env bash

#
# Installs LM Studio, a desktop app for discovering, downloading, and running
# local LLMs.
#
# https://lmstudio.ai/
#

print_step "Installing LM Studio."

# Discover the installed version of LM Studio, if any. The installed binary
# is `lm-studio` (hyphenated), and the dpkg package name matches. Use dpkg
# rather than the binary because it's authoritative for apt-installed packages.
installed_version=""
if dpkg -s lm-studio >/dev/null 2>&1; then
  installed_version=$(dpkg -s lm-studio | grep -oP 'Version: \K\d+\.\d+\.\d+')
fi

# Get the latest version by following the redirect from the canonical AppImage
# download URL. The redirect target encodes the version in its path, e.g.:
# https://installers.lmstudio.ai/linux/x64/0.4.11-1/LM-Studio-0.4.11-1-x64.AppImage
# The .deb package is served at the same path with a .deb extension.
redirect_url=$(curl -sI "https://lmstudio.ai/download/latest/linux/x64" | grep -i "^location:" | tr -d '\r' | awk '{print $2}')
latest_version=$(echo "${redirect_url}" | grep -oP '\d+\.\d+\.\d+(?:-\d+)?(?=/)' | head -1)
deb_url="${redirect_url/.AppImage/.deb}"

if [[ -z "${latest_version}" ]]; then
  print_error "Failed to retrieve the latest LM Studio version."
  exit 1
fi

print_info "Latest available version of LM Studio is v${latest_version}."

# Compare on the 3-part semver only — the dpkg build suffix uses `+N` while
# the upstream URL uses `-N`, so the suffixes can't be compared directly.
latest_base=$(echo "${latest_version}" | grep -oP '^\d+\.\d+\.\d+')
if [[ "${installed_version}" == "${latest_base}" ]]; then
  print_info "Latest version of LM Studio, v${latest_version}, is already installed. Skipping."
else

  if [[ "${installed_version}" == "" ]]; then
    print_info "LM Studio is not currently installed. Will install v${latest_version}."
  else
    print_info "LM Studio v${installed_version} is installed. Will upgrade to v${latest_version}."
  fi

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Fetch the .deb package.
  print_info "Downloading LM Studio v${latest_version} Debian package."
  wget \
    -O "${tmp_dir}/LM-Studio-${latest_version}-x64.deb" \
    "${deb_url}"

  if [[ ! -f "${tmp_dir}/LM-Studio-${latest_version}-x64.deb" ]]; then
    print_error "Failed to download LM Studio Debian package."
    rm -rf "${tmp_dir}"
    exit 1
  fi

  # Install the downloaded .deb file.
  superdo dpkg -i "${tmp_dir}/LM-Studio-${latest_version}-x64.deb"

  # Resolve any missing dependencies.
  superdo apt-get install -f -y

  # Remove the temporary directory and all its contents.
  rm -rf "${tmp_dir}"

  print_success "LM Studio v${latest_version} installed successfully."

fi

# Fix the icon in the desktop entry. The default Icon= value is a named icon
# reference ("lm-studio"), which fails to resolve on most Linux desktops because
# LM Studio does not install an icon into the system icon theme directories.
# Extract a PNG from the bundled .ico file (using icotool from icoutils) and
# point the desktop entry at it.
ico_file="/opt/LM-Studio/resources/icon.ico"
png_file="/opt/LM-Studio/resources/icon.png"
if [[ -f "${ico_file}" ]]; then
  # Frame index 7 is the 512x512 image – the largest available in the .ico.
  superdo icotool -x -i 7 "${ico_file}" -o "${png_file}"
fi

desktop_file="/usr/share/applications/lm-studio.desktop"
if [[ -f "${desktop_file}" && -f "${png_file}" ]]; then
  superdo sed -i "s|^Icon=.*|Icon=${png_file}|" "${desktop_file}"
  print_success "Fixed LM Studio desktop entry icon."
fi

update-desktop-database ~/.local/share/applications/
