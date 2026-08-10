#!/usr/bin/env bash

#
# Install the Docker MCP Gateway CLI plugin (`docker mcp`).
#
# Depends on `exec/docker.sh` for the Docker CLI and cli-plugins directory
# convention. Requires `dev/docker-credential-pass.sh` for the gateway to
# store secrets.
#
# https://github.com/docker/mcp-gateway
# https://dev.to/udondan/running-docker-mcp-gateway-on-linux-without-docker-desktop-4da2
#

print_step "Installing Docker MCP Gateway."

# Check if the plugin is already installed, and which version it is.
installed_version=""
if docker mcp --version >/dev/null 2>&1; then
  installed_version=$(docker mcp --version | grep -oP '\d+\.\d+\.\d+')
fi

# Every release of `docker/mcp-gateway` is flagged as a pre-release, so the
# `/releases/latest` endpoint used by `gh_latest_tag` 404s. Use
# `gh_latest_release_tag` instead, which reads the full releases list.
latest_version=$(gh_latest_release_tag docker/mcp-gateway | sed 's/^v//')

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "Docker MCP Gateway is already installed and at the latest version, v${installed_version}. Skipping."
else

  print_info "Will install/upgrade Docker MCP Gateway to v${latest_version}."

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Fetch the latest release.
  gh_url="https://github.com/docker/mcp-gateway/releases/download/v${latest_version}/docker-mcp-linux-amd64.tar.gz"
  if ! curl -fL -o "${tmp_dir}/docker-mcp.tar.gz" "${gh_url}"; then
    print_error "Failed to download Docker MCP Gateway package from ${gh_url}."
    exit 1
  fi

  # Unpack it to the tmp directory.
  tar xf "${tmp_dir}/docker-mcp.tar.gz" -C "${tmp_dir}"

  # Install it as a Docker CLI plugin.
  superdo mkdir -p -m 755 /usr/local/lib/docker/cli-plugins
  superdo install "${tmp_dir}/docker-mcp" /usr/local/lib/docker/cli-plugins/docker-mcp

  # Remove the temporary directory.
  rm -rf "${tmp_dir}"

  # Print out the installed version.
  print_success "Installed/updated Docker MCP Gateway to v${latest_version}."

fi

docker mcp --version
