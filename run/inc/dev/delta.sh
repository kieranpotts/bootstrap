#!/usr/bin/env bash

#
# Install Delta, the agentic development environment from Zed.
#
# Not to be confused with `git-delta` (see `git-delta.sh`). Both programs
# provide an executable named `delta`, so both can't be installed at the same
# time.
#
# Delta is in public beta. The archive's download URL is resolved from the same
# unauthenticated API that the download page uses. It returns a short-lived
# pre-signed URL, so it must be requested afresh on every run. The archive's
# `install.sh` installs to `~/.local/delta.app` and links `~/.local/bin/delta`.
#
# https://delta.dev/docs/installation
# https://delta.dev/download
#

print_step "Installing Delta."

case "$(uname -m)" in
  x86_64) delta_arch="x86_64" ;;
  aarch64 | arm64) delta_arch="aarch64" ;;
  *)
    print_error "Delta does not support the architecture $(uname -m)."
    exit 1
    ;;
esac

release=$(curl -fsSL "https://delta.dev/api/releases/stable/latest/asset?asset=delta&os=linux&arch=${delta_arch}")
latest_version=$(jq -r '.version' <<<"${release}")
download_url=$(jq -r '.url' <<<"${release}")

if [[ -z "${latest_version}" || "${latest_version}" == "null" || "${download_url}" == "null" ]]; then
  print_error "Failed to resolve the latest Delta release."
  exit 1
fi

print_info "Latest available version of Delta is v${latest_version}."

# Discover the installed version of Delta, if it exists.
installed_version=""
if [[ -x "${HOME}/.local/bin/delta" ]]; then
  installed_version=$(timeout 10 "${HOME}/.local/bin/delta" --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 || true)
fi

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "Latest version of Delta, v${latest_version}, is already installed. Skipping."
else

  print_info "Installing/updating Delta v${latest_version} from release archive."

  # Remember the current working directory, so we can change back here later.
  cwd=$(pwd)

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)
  cd "${tmp_dir}" || exit 1

  curl -fsSL -o delta.tar.gz "${download_url}"

  if [[ ! -s delta.tar.gz ]]; then
    print_error "Failed to download the Delta archive."
    exit 1
  fi

  tar -xzf delta.tar.gz
  ./Delta/install.sh

  # Move back to the original directory.
  cd "${cwd}" || true

  # Remove the temporary directory and all its contents.
  rm -rf "${tmp_dir}"

  print_success "Delta v${latest_version} installed successfully."

fi
