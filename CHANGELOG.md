# Changelog

## [Unreleased]

- Remove `git-secrets`.
- Install GitHub CLI (`gh`).
- Renamed entry script from `run/bootstrap.sh` to `run/bootstrap` (now executable).
- Added `--gui` feature toggle for opting into GUI installs; install steps can check via the new `is_gui_enabled` helper.

## [1.2.0] - 2026-05-15

- Renamed container name: kieranpotts/devenv → kieranpotts/devcontainer.
- Installed rocm-smi.
- Added Git pre-commit.com hook framework.

## [1.1.0] - 2026-04-06

- Small fixes.

## [1.0.0] - 2026-03-20

- Initial release.
- Docker-aware scripts.
