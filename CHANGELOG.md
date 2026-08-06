# Changelog

## [Unreleased]

- feature: add `./run/update` for updating an already-provisioned machine
- refactor: `./run/update` skips installation of tools that already exist
- feature: install amdgpu_top
- feature: install orca screen reader
- feature: install pied (UI for piper)
- feature: install voxd
- feature: install litellm
- feature: install docker-credential-pass and wire it up as a `docker pass` CLI plugin
- feature: install Docker MCP Gateway (`docker mcp`)
- feature: install codespell
- feature: enable oh-my-posh auto-updates

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
