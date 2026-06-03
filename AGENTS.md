# Bootstrap

## Project overview

Provisioning scripts for a standard local development environment on Debian-based Linux – which may include Ubuntu 24.04 LTS under WSL2.

The scripts are idempotent – safe to re-run to pick up new changes.

The boostrap script may be used to provision host environments, or to create an image for a containerized environment. [`docker-devcontainer`](https://hub.docker.com/r/kieranpotts/docker-devcontainer) is a Docker image that can be used for a guest [devcontainer](https://containers.dev/), as an alternative to installing the bootstrap scripts directly on a host machine.

Tagged released of this repository are used to pin builds of the [`docker-devcontainer`](https://hub.docker.com/r/kieranpotts/docker-devcontainer) image to a known good state.

## Tech stack

- Bash, targeting Debian-based Linux (`apt`, `dpkg`).
- ShellCheck for static analysis.

## Repository structure

- `run/bootstrap`: Entry script, sources every install step in order.
- `run/inc/fn/`: Shared helper functions (`print_step`, `superdo`, `is_gui_enabled`, status printers).
- `run/inc/var/`: Shared variables (ANSI codes).
- `run/inc/msg/`: Start and finish banners.
- `run/inc/sys/`: Compatibility checks, APT setup, system updates, upgrades, and teardown.
- `run/inc/util/`: General utilities (curl, git, gnupg, wget, …).
- `run/inc/run/`: Language runtimes (Node, JDK, PHP, Python).
- `run/inc/dev/`: Developer tooling (Claude, Copilot, delta, lazygit, …).
- `run/inc/ops/`: Ops tooling (AWS CLI, Terraform).
- `run/inc/phy/`: Hardware-related tooling (eg. ROCm).
- `docs/`: Installation, requirements, releasing, and considerations.

## Tools

- `./run/bootstrap` to provision a target machine (CLI tools only).
- `./run/bootstrap --gui` to additionally install GUI applications.
- `./run/bootstrap --help` to print the usage banner.
- `shellcheck run/**/*.sh run/bootstrap` to lint shell scripts.

## Feature toggles

CLI flags are parsed at the top of `run/bootstrap` and stored as global variables that any sourced install step can inspect via helpers in `run/inc/utils.sh`:

- `--gui` sets `install_gui=1`. Install steps that should only run with this flag must guard themselves with `is_gui_enabled || return 0` immediately before their `print_step` call.

Defaults are conservative: with no flags, only CLI tooling is installed.

## Rules

The capitalized words REQUIRED, MUST, MUST NOT, RECOMMENDED, SHOULD, SHOULD NOT, OPTIONAL, and MAY, in the context of this document and agent skills/instructions/rules, are to be interpreted as described in [IETF RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

- MUST keep every script idempotent. Running `./run/bootstrap` repeatedly must converge, not duplicate, work.

- MUST call `print_step "…"` as the first non-comment line of every install step, so the run is self-narrating.

- MUST use the `superdo` helper instead of `sudo` directly, so scripts work both as root (eg. for Docker builds) and as a regular user (for local installs).

- MUST source every new install script from `run/bootstrap` in the correct group, sorted alphabetically within that group.

- MUST target Debian-based distros only. Do not add steps that assume other package managers besides APT.

- MUST NOT commit ad-hoc one-off scripts to `run/inc/`. Each file installs or configures one named tool.

- SHOULD pin upstream versions when the project publishes stable tags or `.deb` artifacts, so devcontainer builds are reproducible.

- SHOULD restore the original working directory and clean up any temporary directories created during an install step.

- SHOULD add an "[Unreleased]" entry to `CHANGELOG.md` when adding, removing, or materially changing an install step.

## Skills

The following skills, scoped to this project, are installed in the `./agents/skills/` directory:

- [`./agents/skills/apt/SKILL.md`](./skills/apt/SKILL.md): Use the APT package manager correctly in bootstrap scripts.

- [`./agents/skills/install-step/SKILL.md`](./skills/install-step/SKILL.md): Add or modify an install step in the bootstrap scripts.
