#!/usr/bin/env bash

#
# Install amdgpu_top, a terminal utility for monitoring AMD GPU utilization
# (performance counters, sensors, fdinfo, VRAM/engine usage).
#
# https://github.com/Umio-Yasuno/amdgpu_top
#

print_step "Installing amdgpu_top."

# No-op on `./run/update`. Don't install new tools when updating.
if is_updating && ! dpkg -s amdgpu-top >/dev/null 2>&1; then
  return 0
fi

# Get the latest version from the GitHub releases page (strip leading `v`).
latest_version=$(gh_latest_tag Umio-Yasuno/amdgpu_top | sed 's/^v//')

if [[ -z "${latest_version}" ]]; then
  print_error "Failed to retrieve the latest version of amdgpu_top. Skipping."
else

  print_info "Latest available version of amdgpu_top is v${latest_version}."

  # Use dpkg to check the installed version. This is preferable to
  # `amdgpu_top --version` because dpkg is authoritative for anything
  # installed via a .deb package.
  installed_version=""
  if dpkg -s amdgpu-top >/dev/null 2>&1; then
    installed_version=$(dpkg -s amdgpu-top | grep -oP 'Version: \K[0-9]+\.[0-9]+\.[0-9]+')
  fi

  if [[ "${installed_version}" == "${latest_version}" ]]; then
    print_info "Latest version of amdgpu_top, v${latest_version}, is already installed. Skipping."
  else

    print_info "Installing/updating amdgpu_top from .deb package."

    # The "without_gui" build is the plain terminal-UI tool, with no GTK/egui
    # dependencies - this is a hardware monitoring CLI, not a desktop app, so
    # it installs regardless of `--gui` (see `run/inc/phy/rocm.sh`).
    deb_url=$(gh_asset_url Umio-Yasuno/amdgpu_top 'amdgpu-top_without_gui_.*_amd64\.deb$')

    if [[ -z "${deb_url}" ]]; then
      print_error "Failed to find the amdgpu_top .deb package in the latest release. Skipping."
    else

      cwd=$(pwd)
      tmp_dir=$(mktemp -d)
      cd "${tmp_dir}" || true

      wget -q -O amdgpu-top.deb "${deb_url}"

      superdo apt-get install -f -y ./amdgpu-top.deb

      cd "${cwd}" || true
      rm -rf "${tmp_dir}"

      print_success "amdgpu_top v${latest_version} installed successfully."

    fi
  fi
fi

# Note: `amdgpu_top` has no `--version` flag - passing one falls through to
# its default GPU-probing behaviour, which panics on a machine with no AMD
# GPU or an unloaded amdgpu driver. `--help` is the only safe, argument-free
# way to confirm the installed version; its first line is `amdgpu_top X.Y.Z`.
command -v amdgpu_top >/dev/null 2>&1 && amdgpu_top --help | head -1
