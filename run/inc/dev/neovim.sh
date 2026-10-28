#!/usr/bin/env bash

#
# Install Neovim.
#
# Installed from the prebuilt tarball published with each upstream GitHub
# release, unpacked to `/opt/nvim` and symlinked into `/usr/local/bin`. The
# version in the Ubuntu archive is old.
#
# https://github.com/neovim/neovim/blob/master/INSTALL.md
#

print_step "Installing Neovim."

# Remove any copy installed from APT (eg. from a third-party repository), so
# it cannot shadow or conflict with the release install below.
if dpkg -s neovim >/dev/null 2>&1; then
  print_info "Removing Neovim installed via APT."
  superdo apt-get remove -y neovim neovim-runtime
fi

# Upstream tags carry a leading `v`, as does the output of `nvim --version`.
latest_version=$(gh_latest_tag neovim/neovim)

installed_version=""
if [[ -x /opt/nvim/bin/nvim ]]; then
  installed_version=$(/opt/nvim/bin/nvim --version | head -1 | grep -oP 'NVIM \K\S+')
fi

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "Neovim is already installed and at the latest version, ${installed_version}. Skipping."
else

  print_info "Will install/upgrade Neovim to ${latest_version}."

  tarball_url=$(gh_asset_url neovim/neovim 'nvim-linux-x86_64\.tar\.gz$')

  cwd=$(pwd)
  tmp_dir=$(mktemp -d)
  cd "${tmp_dir}" || exit 1

  curl -fLo nvim.tar.gz "${tarball_url}"
  tar xf nvim.tar.gz

  superdo rm -rf /opt/nvim
  superdo mv nvim-linux-x86_64 /opt/nvim

  cd "${cwd}" || true
  rm -rf "${tmp_dir}"

fi

superdo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
nvim --version | head -1
