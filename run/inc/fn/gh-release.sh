#!/usr/bin/env bash

#
# Helpers for fetching information from the GitHub Releases API.
#
# Unauthenticated requests to api.github.com are capped at 60/hour per
# source IP. A single bootstrap run makes ~18 calls through these helpers
# (one or more per tool that installs from GitHub Releases), which is enough
# on its own to exhaust that budget partway through a run - and easily
# exhausted sooner on a machine that has bootstrapped more than once in the
# same hour. When the limit is hit, `curl` still exits 0 (the API replies
# with HTTP 403, not a network error), so `tag_name`/`browser_download_url`
# just came back empty and callers silently built malformed URLs (eg.
# ".../releases/download/v/ctop--linux-amd64", missing the version) that
# failed much later with a confusing "curl: (22) 404", far from the real
# cause.
#
# Fix: prefer the `gh` CLI, which the "Install GitHub CLI" step installs and
# authenticates earlier in the run. Authenticated requests get a 5,000/hour
# budget, comfortably covering a full run (and several re-runs) that would
# blow through the unauthenticated 60/hour limit. Fall back to plain curl if
# `gh` isn't installed/authenticated, and in either case fail loudly with a
# rate-limit hint instead of returning an empty string, so a still-exhausted
# budget is obvious at the source rather than surfacing as a downstream 404.
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
  local tag=""

  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    tag=$(gh api "repos/${repo}/releases/latest" --jq '.tag_name' 2>/dev/null)
  else
    tag=$(curl -s "https://api.github.com/repos/${repo}/releases/latest" \
      | grep -Po '"tag_name": "\K[^"]*')
  fi

  if [[ -z "${tag}" ]]; then
    print_error "Could not determine the latest release tag for ${repo}. This is usually the GitHub API rate limit (60/hour unauthenticated, 5,000/hour if 'gh' is authenticated); it resets hourly, so re-running the bootstrap later should succeed."
    return 1
  fi

  echo "${tag}"
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
  local url=""

  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    url=$(gh api "repos/${repo}/releases/latest" --jq '.assets[].browser_download_url' 2>/dev/null \
      | grep -E -- "${pattern}" \
      | head -1)
  else
    url=$(curl -s "https://api.github.com/repos/${repo}/releases/latest" \
      | grep -oP '"browser_download_url": "\K[^"]+' \
      | grep -E -- "${pattern}" \
      | head -1)
  fi

  if [[ -z "${url}" ]]; then
    print_error "Could not find a release asset for ${repo} matching '${pattern}'. This is usually the GitHub API rate limit (60/hour unauthenticated, 5,000/hour if 'gh' is authenticated); it resets hourly, so re-running the bootstrap later should succeed."
    return 1
  fi

  echo "${url}"
}
