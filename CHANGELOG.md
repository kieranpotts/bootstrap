# Changelog

## [Unreleased]

- Install Zellij (`zellij`), a terminal multiplexer, in the `tui` profile.
- behavior: `htop` moves from unconditional (every profile) to a `tui_step`,
  so it is no longer installed under `--profile=cli` - it's an interactive
  tool for a human, not plumbing a headless container needs.
- behavior: `--profile` is now required, with no default. Omitting it at a
  terminal prompts for `cli`, `tui`, or `gui`, re-prompting on an invalid
  answer; omitting it in a non-interactive run (no TTY on stdin - a
  `docker build` layer, CI, a piped/logged run) is now an error rather than
  a silent `tui`.
- behavior: rename the `agent` install profile to `cli`. `--profile=cli`
  replaces `--profile=agent` (the old value now errors, like any other
  invalid `--profile`), and `agent_step`/`is_agent_profile` are renamed to
  `cli_step`/`is_cli_profile`. What the profile installs is unchanged.
- fix: `./run/install --profile=<value>` now errors on an empty or invalid
  value with a dedicated message, rather than falling through to the
  generic "Unknown argument" case. `--profile=tui` is also now accepted
  explicitly, matching `agent`/`cli` and `gui`.
- behavior: remove the per-tool install/update prompts and the `--yes`/`-y`
  flag. Every step now runs unattended regardless of profile. Drops
  `is_yes_enabled` and the `assume_yes` flag, and the now-unused
  display-name argument to `agent_step`/`tui_step`/`gui_step` and every
  call site in `run_install_steps`.
- behavior: remove `./run/update`. `./run/install` is idempotent and now
  the only entry point - re-run it to pick up updates on an
  already-provisioned machine. Drops the `updating`/`is_updating` guard and
  every per-step branch that used it, so every run performs the full
  install sequence rather than skipping first-time-only work.
- fix: `step()` now explicitly turns `-u`/`pipefail` back off inside the
  per-step subshell, matching the documented intent that steps run under
  `set -e` only. Bash subshells inherit every option from the parent, so the
  entry point's full strict mode (`set -euo pipefail`) was leaking into
  every step - eg. `node.sh`/`rust.sh` re-sourcing the user's real
  `~/.bashrc` and aborting on an unset variable referenced by a third-party
  init script (`~/.inshellisense/init/bash/init.sh`).
- fix: `oh-my-posh enable upgrade`, not `oh-my-posh enable autoupgrade` -
  the upstream CLI renamed the auto-upgrade feature and now rejects the old
  name.
- fix: pass `--` to `grep -E` in `gh_asset_url`, so an asset-matching
  pattern that starts with `-` (eg. Pied's `-x86_64\.tar\.gz$`) is not
  misparsed as `grep` options.
- behavior: add guard to protect against injection of `.npmrc` settings that
  are incompatible with `nvm`.
- feature: replace `--gui` with a single `--profile=agent|tui|gui` flag,
  defaulting to `tui` - BREAKING. The three profiles are cumulative, and
  `--gui` now exits with an error pointing at `--profile=gui`. What each
  profile installs is unchanged from the previous flag combinations:
  `--profile=tui` matches the old flagless run, `--profile=gui` the old
  `--gui` run.
- refactor: declare profile membership at the call site, via `agent_step`,
  `tui_step`, and `gui_step` in `run/inc/fn/install-steps.sh`, replacing
  `core_step`/`confirm_step` and removing the `is_gui_enabled` guard from 37
  install steps. Install steps no longer branch on the profile at all
- refactor: rename `run/inc/fn/gui.sh` to `run/inc/fn/profile.sh`, and
  replace `is_gui_enabled` with `profile_at_least`
- refactor: prompting is now decided by whether a call site passes a display
  name, independently of the profile. Steps outside the selected profile are
  skipped silently
- feature: install FFmpeg
- feature: install dive
- feature: install editorconfig-checker
- feature: install lynx
- feature: install gh-dash
- feature: install inshellisense
- feature: install lazynpm
- feature: prompt for confirmation before each app/dev/ops/phy/web install or update
- feature: add `--yes`/`-y` to skip all prompts
- feature: install Rust and Cargo via Rustup
- refactor: rename `./run/bootstrap` to `./run/install`
- feature: add `./run/update` for updating an already-provisioned machine
- refactor: `./run/update` skips installation of tools that already exist
- feature: enable oh-my-posh auto-updates
- feature: install amdgpu_top
- feature: install orca screen reader
- feature: install pied (UI for piper)
- feature: install voxd
- feature: install litellm
- feature: install docker-credential-pass and wire it up as a `docker pass` CLI plugin
- feature: install Docker MCP Gateway (`docker mcp`)
- feature: install codespell
- fix: use `superdo` (not `sudo` directly) for ROCm and Microsoft Edge installs
- feature: add the `agent` profile, a minimal tool set suited to a coding
  agent in a headless container - see `docs/tools.md`
- feature: install Node.js and Python in every profile, including `agent`
- refactor: install Docker CE, OpenJDK, PHP, and Rust via a prompt instead
  of unconditionally, so they're skippable and excluded from the `agent`
  profile
- refactor: recategorize Open WebUI as a GUI app (`run/inc/app/`, in the
  `gui` profile), not a CLI dev tool
- fix: FFmpeg install no longer pulls in a MIDI soundfont
  (`--no-install-recommends`)
- docs: add `docs/tools.md`, an Agent/TUI/GUI table of what installs where
- fix: lint `run/install` and `run/update` in the ShellCheck workflow - the
  `find` pattern only matched `*.sh` files and `run/bootstrap`
- fix: `./run/update --help` no longer truncates its usage banner
  mid-sentence
- docs: document the install profiles in `docs/installation.md`, and correct
  the claim that language runtimes are never prompted
- docs: correct `docs/considerations.md`, which claimed the bootstrap does
  not install Docker
- docs: bring the `install-step` skill back in line with the codebase
  (`core_step`/agent profile, group names, shebang, required doc updates)
- refactor: gate the Bruno, Microsoft, Mozilla, SourceGit, VSCodium, and
  Warp APT registries behind `--gui` - every package they serve is a
  GUI-only install
- maintenance: run editorconfig-checker and codespell in CI
- docs: drop the "pin upstream versions" rule, which no install step
  followed - versions resolve at run time, and the git tag on this
  repository is the reproducibility pin

## [1.5.0] - 2026-07-24

- feature: install déjà dup backups
- feature: install draw.io
- feature: install dropbox
- feature: install obsidian
- feature: install aider
- feature: install bruno
- feature: install cline
- feature: install continue
- feature: install cursor cli and gui
- feature: install frame0
- feature: install hermes agent
- feature: install insomnia
- feature: install jetbrains toolbox
- feature: install lm studio
- feature: install ollama
- feature: install open web ui
- feature: install openclaw
- feature: install postman
- feature: install qwen code
- feature: install sourcegit
- feature: install vs code insiders
- feature: install vscodium
- feature: install warp
- feature: install htop
- feature: install icoutils
- feature: install inotify tools
- feature: install jq

## [1.4.0] - 2026-07-24

This release sees the removal of Docker Desktop. On Linux it runs its own
daemon in a VM and hijacks the active Docker CLI context (flipping it to
`desktop-linux` while running, `default` when stopped), which conflicted with
the native Docker Engine and broke tools that follow the default daemon — most
notably VS Code devcontainers, which failed to start whenever Desktop was not
running. The native engine alone is simpler and avoids the conflict.

- feature: remove docker desktop - BREAKING
- feature: add lazydocker and ctop
- feature: install pass in all environments
- feature: install pi
- feature: add XPDF Reader

## [1.3.5] - 2026-06-08

- fix: guard against missing systemd

## [1.3.4] - 2026-06-08

- fix: select appropriate linux distro target for docker
- fix: export phpenv bin to path
- fix: export ~/.local/bin tp path so poetry/pipx binaries immediately available

## [1.3.3] - 2026-06-08

- fix: unbound variables
- fix: reading of ubuntu package registries from plain debian distros
- fix: skip some package registries requires only for gui apps

## [1.3.2] - 2026-06-08

- fix: fallback for missing `ID_LIKE` env var from `/etc/os-release`

## [1.3.1] - 2026-06-08

- fix: system check (fails on debian bookworm)

## [1.3.0] - 2026-06-08

- feature: install ghostty
- feature: install `ripgrep`
- feature: remove `git-secrets`
- feature: install GitHub CLI (`gh`)
- refactor: renamed entry script from `run/bootstrap.sh` to `run/bootstrap` (now executable)
- feature: added `--gui` feature toggle for opting into GUI installs; install steps can check via the new `is_gui_enabled` helper
- maintenance: added Zed settings
- maintenance: added pre-commit hooks

## [1.2.0] - 2026-05-15

- refactor: renamed container name: kieranpotts/devenv → kieranpotts/devcontainer.
- feature: install rocm-smi.
- feature: add git pre-commit.com hook framework

## [1.1.0] - 2026-04-06

- small fixes

## [1.0.0] - 2026-03-20

- initial release
- docker-aware scripts
