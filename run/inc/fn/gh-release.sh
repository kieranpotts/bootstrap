#!/usr/bin/env bash

#
# Helpers for fetching information from the GitHub Releases API.
#

# gh_latest_tag - Print the `tag_name` of the latest release for a GitHub repo.
#
# Arguments:
#   $1 - GitHub repo in `owner/name` form (eg. `jesseduffield/lazygit`).
#
# Output:
#   The tag exactly as returned by the API, eg. `v0.42.0` or `0.42.0`.
#   Callers should strip the leading `v` themselves if they don't want it.
#
gh_latest_tag() {
  local repo="$1"
  curl -s "https://api.github.com/repos/${repo}/releases/latest" \
    | grep -Po '"tag_name": "\K[^"]*'
}

# gh_asset_url - Print the first `browser_download_url` whose path matches a
# pattern, from the latest release of a GitHub repo.
#
# Arguments:
#   $1 - GitHub repo in `owner/name` form.
#   $2 - `grep -E` pattern to match against the URL.
#
# Output:
#   The first matching URL, or empty if none match.
#
gh_asset_url() {
  local repo="$1"
  local pattern="$2"
  curl -s "https://api.github.com/repos/${repo}/releases/latest" \
    | grep -oP '"browser_download_url": "\K[^"]+' \
    | grep -E "${pattern}" \
    | head -1
}
