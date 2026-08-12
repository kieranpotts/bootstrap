# Changelog

## [Unreleased]

**Added**
- Install Vim (`vim-tiny`) in the `cli` profile, alongside Neovim's `tui` install.
- Install less in the `cli` profile.
- Install procps in the `cli` profile.
- Install psmisc in the `cli` profile.
- Install lsof in the `cli` profile.
- Install file in the `cli` profile.

## [1.6.0] - 2026-08-10

This release focused on extensive refactoring. In addition to the final
featureset, experimental changes including introducing per-tool install
prompts (ultimately rejected), a sibling `./run/update` script (also rejected),
and various designs for the installation profiles.

**Added**
- Add required installation `--profile`, must be one of: `cli`, `tui`, `gui`.
- Install Zellij (`tmux` alternative).
- Install FFmpeg.
- Install Dive (Docker image inspector).
- Install EditorConfig Checker (`ec`).
- Install Lynx text-only web browser.
- Install `gh-dash` (TUI for GitHub CLI).
- Install Inshellisense.
- Install `lazynpm`.
- Install Rust and Cargo via Rustup.
- Install `amdgpu_top`.
- Install Orca screen reader
- Install Pied (UI for Piper)
- Install Voxd.
- Install LiteLLM.
- Install docker-credential-pass and wire it up as a `docker pass` CLI plugin.
- Install Docker MCP Gateway (`docker mcp`).
- Install `codespell`.

**Changed**
- Rename `./run/bootstrap` to `./run/install`.
- Move `htop` to TUI installation profile.
- Enable oh-my-posh auto-updates.
- FFmpeg install no longer pulls in a MIDI soundfont (`--no-install-recommends`).
- Gate the Bruno, Microsoft, Mozilla, SourceGit, VSCodium, and Warp APT
  registries behind the GUI installation profile.
- Run `editorconfig-checker` and `codespell` in CI.

**Fixed**
- Add guard to protect against injection of `.npmrc` settings that are
  incompatible with NVM.
- `step()` now explicitly turns `-u`/`pipefail` back off inside the per-step
  sub-shell. Bash sub-shells inherit every option from the parent shell, so the
  entry point's fully-strict mode (`set -euo pipefail`) was leaking into
  every step. This had consequences when subsequent steps did things like
  re-source the user's real `~/.bashrc` and fail on an unset variable
  referenced by a third-party init script (eg. for inshellisense).
- Change `oh-my-posh enable autoupgrade` to `oh-my-posh enable upgrade`,
  the new CLI option.
- Pass `--` to `grep -E` in `gh_asset_url`, so an asset-matching
  pattern that starts with `-` (eg. Pied's `-x86_64\.tar\.gz$`) is not
  wrongly parsed as `grep` options.
- Fix use of `sudo` (→ `superdo`) for ROCm and Microsoft Edge installs.
- Fix clone of `~/.phpenv` and the `php-build` plugin if `git pull` fails due
  to the default branch changing on an existing checkout — it had been changed
  from `master` to `main`.
- `gh_latest_tag`/`gh_asset_url` now query the GitHub API via the authenticated
  `gh` CLI instead of unauthenticated `curl` (60/hour), falling back to `curl`
  only if `gh` isn't installed/authenticated. A full bootstrap run makes enough
  GitHub Releases API calls on its own to exhaust the unauthenticated limit
  (5,000 requests/hour) partway through.
- Both `gh_latest_tag`/`gh_asset_url` functions now also fail loudly with a
  rate-limit hint if no tag/asset is found, instead of returning empty.
- Add `gh_latest_release_tag`, and use it in the Docker MCP Gateway install.
  Every `docker/mcp-gateway` release is flagged as a pre-release, so it
  can't use `gh_latest_tag`'s `/releases/latest` endpoint. It had its own
  inline unauthenticated `curl` call to the full releases list, bypassing the
  `gh` CLI hardening.
- Retry `apt-get update` up to 3 times in the system update step. A
  third-party APT mirror mid-sync can transiently fail the fetch.

## [1.5.0] - 2026-07-24

This release ported programs from the sibling bootstrap script in
my private enterprise account.

**Added**
- Install Déjà Dup Backups.
- Install Draw.io.
- Install Dropbox.
- Install Obsidian.
- Install Aider.
- Install Bruno.
- Install Cline.
- Install Continue.
- Install Cursor (both CLI and GUI).
- Install Frame0.
- Install Hermes Agent.
- Install Insomnia.
- Install Jetbrains Toolbox.
- Install LM Studio.
- Install Ollama.
- Install Open Web UI.
- Install OpenClaw.
- Install Postman.
- Install Qwen Code.
- Install SourceGit.
- Install VS Code Insiders.
- Install VSCodium.
- Install Warp.
- Install `htop`.
- Install `icoutils`.
- Install inotify tools.
- Install `jq`.

## [1.4.0] - 2026-07-24

This release sees the removal of Docker Desktop. On Linux it runs its own
daemon in a VM and hijacks the active Docker CLI context, flipping it to
`desktop-linux` while running, `default` when stopped. This conflicted with
the native Docker Engine and broke tools that follow the default daemon —
notably VS Code devcontainers, which failed to start whenever Docker Desktop
was not running. The native engine alone is simpler and avoids the conflict.

**Removed**
- Remove Docker Desktop.

**Added**
- Install `lazydocker` and `ctop`.
- Install `pass` in all environments.
- Install the Pi coding agent harness.
- Install XPDF Reader.

## [1.3.5] - 2026-06-08

**Fixed**
- Guard against missing systemd.

## [1.3.4] - 2026-06-08

**Fixed**
- Select appropriate Linux distro target for Docker.
- Export `phpenv` bin to `PATH`.
- Export `~/.local/bin` to `PATH`, so `poetry`/`pipx` binaries are immediately
  available.

## [1.3.3] - 2026-06-08

**Fixed**
- Fix nbound variables.
- Fix reading of ubuntu package registries from plain debian distros.

**Improved**
- Skip some package registries required only for GUI apps.

## [1.3.2] - 2026-06-08

**Fixed**
- Add fallback for missing `ID_LIKE` env var from `/etc/os-release`.

## [1.3.1] - 2026-06-08

**Fixed**
- Fix system check (failed on Debian bookworm).

## [1.3.0] - 2026-06-08

**Added**
- Add `--gui` feature toggle to opt-in to GUI program installs.
- Install Ghostty.
- Install `ripgrep`.
- Install GitHub CLI (`gh`).
- Add Zed settings.
- Add pre-commit hooks.

**Removed**
- Remove `git-secrets`.

**Changed**
- Rename entry script from `run/bootstrap.sh` to `run/bootstrap`.

## [1.2.0] - 2026-05-15

**Added**
- Install `rocm-smi`.
- Install `pre-commit` Git hook framework.

**Changed**
- Rename container name: `kieranpotts/devenv` → `kieranpotts/devcontainer`.

## [1.1.0] - 2026-04-06

- Small fixes.

## [1.0.0] - 2026-03-20

- Initial release.
- Docker-aware scripts.
