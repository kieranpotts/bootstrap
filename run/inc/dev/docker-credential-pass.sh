#!/usr/bin/env bash

#
# Install `docker-credential-pass`, the `pass`-backed Docker credential
# helper, so that Docker stores registry credentials in a GPG-encrypted
# password store rather than base64-encoded in `~/.docker/config.json`, and
# does so without depending on Docker Desktop.
#
# Also wires the helper up as a Docker CLI plugin (`docker pass`), which is
# what allows the Docker MCP Gateway to store secrets on hosts where that
# gateway is installed.
#
# Depends on `pass` - installed via `app/pass.sh`, but note that `pass` must
# additionally be initialized against a GPG key by hand before Docker can
# use it.
#
# https://github.com/docker/docker-credential-helpers
# https://dev.to/udondan/running-docker-mcp-gateway-on-linux-without-docker-desktop-4da2
#

print_step "Installing docker-credential-pass."

# Check if the helper is already installed, and which version it is.
installed_version=""
if command -v docker-credential-pass >/dev/null 2>&1; then
  installed_version=$(docker-credential-pass version | grep -oP '\d+\.\d+\.\d+' | head -1)
fi

# Get the latest version from the GitHub releases page (strip leading `v`).
latest_version=$(gh_latest_tag docker/docker-credential-helpers | sed 's/^v//')

if [[ "${installed_version}" == "${latest_version}" ]]; then
  print_info "docker-credential-pass is already installed and at the latest version, v${installed_version}. Skipping."
else

  print_info "Will install/upgrade docker-credential-pass to v${latest_version}."

  # Create a temporary directory.
  tmp_dir=$(mktemp -d)

  # Download the release binary (no archive, ships as a raw binary asset).
  gh_url="https://github.com/docker/docker-credential-helpers/releases/download/v${latest_version}/docker-credential-pass-v${latest_version}.linux-amd64"
  if ! curl -fL -o "${tmp_dir}/docker-credential-pass" "${gh_url}"; then
    print_error "Failed to download docker-credential-pass package from ${gh_url}."
    exit 1
  fi

  superdo install "${tmp_dir}/docker-credential-pass" /usr/local/bin/docker-credential-pass

  # Remove the temporary directory.
  rm -rf "${tmp_dir}"

  print_success "Installed/updated docker-credential-pass to v${latest_version}."

fi

# Wire it up as a `docker pass` CLI plugin so `docker mcp` can find it.
superdo mkdir -p -m 755 /usr/local/lib/docker/cli-plugins
superdo tee /usr/local/lib/docker/cli-plugins/docker-pass > /dev/null << 'EOF'
#!/bin/bash
if [[ "$1" == "docker-cli-plugin-metadata" ]]; then
  echo '{"SchemaVersion":"0.1.0","Vendor":"Docker","Version":"v1.0.0","ShortDescription":"Docker Pass secrets helper"}'
  exit 0
fi
exec docker-credential-pass "$@"
EOF
superdo chmod +x /usr/local/lib/docker/cli-plugins/docker-pass

docker-credential-pass version
