#!/usr/bin/env bash

#
# Pipe is a local-first text-to-speech program that runs quickly on modest
# hardware, and is open source. The easiest way to install it is to use Pied,
# which is a simple GUI for selecting languages and accents.
#
# Piper works with Speech Dispatcher, so that gets installed, too.
#
# https://github.com/Elleo/pied
# https://github.com/OHF-Voice/piper1-gpl
#

is_gui_enabled || return 0

print_step "Installing Pied."

# The extracted bundle embeds its own version number in a JSON asset - read
# that back out to check whether Pied is installed, and if so, which version.
installed_version=""
version_file="/opt/pied/data/flutter_assets/version.json"
if [[ -f "${version_file}" ]]; then
  installed_version=$(jq -r '.version' "${version_file}")
fi

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && [[ -z "${installed_version}" ]]; then
  return 0
fi

# Pied configures Speech Dispatcher to use Piper voices, so Speech Dispatcher
# must be present for it to have anything to configure.
superdo apt-get install -y speech-dispatcher

# Pied ships as a Flatpak bundle or a prebuilt x86_64 tarball - no .deb
# package or apt-friendly release is published. Flatpak is intentionally
# avoided in this project (see `run/inc/app/deja-dup.sh`), so install the
# tarball build into /opt instead, following the same pattern used for
# Postman (see `run/inc/dev/postman.sh`).

latest_version=$(gh_latest_tag Elleo/pied | sed 's/^v//')

if [[ -z "${latest_version}" ]]; then
  print_error "Failed to retrieve the latest version of Pied. Skipping."
else

  print_info "Latest available version of Pied is v${latest_version}."

  if [[ "${installed_version}" == "${latest_version}" ]]; then
    print_info "Latest version of Pied, v${latest_version}, is already installed. Skipping."
  else

    print_info "Installing/updating Pied from release tarball."

    tar_url=$(gh_asset_url Elleo/pied '-x86_64\.tar\.gz$')

    if [[ -z "${tar_url}" ]]; then
      print_error "Failed to find the Pied x86_64 tarball in the latest release. Skipping."
    else

      cwd=$(pwd)
      tmp_dir=$(mktemp -d)
      cd "${tmp_dir}" || true

      wget -q -O pied.tar.gz "${tar_url}"

      # Remove any previous install so stale libraries/assets from an older
      # version aren't left behind alongside the new ones.
      superdo rm -rf /opt/pied
      superdo tar -xzf pied.tar.gz -C /opt
      superdo ln -sf /opt/pied/pied /usr/local/bin/pied

      mkdir -p ~/.local/share/applications
      cat > ~/.local/share/applications/pied.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=Pied
Comment=Install and manage Piper text-to-speech voices
Exec=/opt/pied/pied %U
Icon=/opt/pied/data/flutter_assets/assets/icon.png
Terminal=false
Type=Application
Categories=Utility;Accessibility;
EOF
      update-desktop-database ~/.local/share/applications/

      cd "${cwd}" || true
      rm -rf "${tmp_dir}"

      print_success "Pied v${latest_version} installed successfully."

    fi
  fi
fi
