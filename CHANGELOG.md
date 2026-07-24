# Changelog

## [Unreleased]

- feature: install déjà dup backups
- feature: install draw.io
- feature: install dropbox
- feature: install obsidian
- feature: install aider
- feature: install bruno

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

- Fix unbound variables.
- Fix reading of Ubuntu package registries from plain Debian distros.
- Skip some package registries requires only for GUI apps.

## [1.3.2] - 2026-06-08

- Fallback for missing `ID_LIKE` env var from `/etc/os-release`.

## [1.3.1] - 2026-06-08

- Fix system check (fails on Debian bookworm).

## [1.3.0] - 2026-06-08

- Install Ghostty.
- Install `ripgrep`.
- Remove `git-secrets`.
- Install GitHub CLI (`gh`).
- Renamed entry script from `run/bootstrap.sh` to `run/bootstrap` (now executable).
- Added `--gui` feature toggle for opting into GUI installs; install steps can check via the new `is_gui_enabled` helper.
- Added Zed settings.
- Added pre-commit hooks.

## [1.2.0] - 2026-05-15

- Renamed container name: kieranpotts/devenv → kieranpotts/devcontainer.
- Installed rocm-smi.
- Added Git pre-commit.com hook framework.

## [1.1.0] - 2026-04-06

- Small fixes.

## [1.0.0] - 2026-03-20

- Initial release.
- Docker-aware scripts.
