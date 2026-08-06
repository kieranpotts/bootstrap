# Bootstrap

Provisioning scripts for a standard local development environment on
Debian-based Linux – which may include Ubuntu 24.04 LTS under WSL2.

The scripts are idempotent – safe to re-run to pick up new changes.

The bootstrap script may be used to provision host environments, or to create
an image for a containerized environment.
[`docker-devcontainer`](https://hub.docker.com/r/kieranpotts/docker-devcontainer)
is a Docker image that can be used for a guest
[devcontainer](https://containers.dev/), as an alternative to installing
the bootstrap scripts directly on a host machine.

Tagged released of this repository are used to pin builds of the
[`docker-devcontainer`](https://hub.docker.com/r/kieranpotts/docker-devcontainer)
image to a known good state.

The capitalized words REQUIRED, MUST, MUST NOT, RECOMMENDED, SHOULD,
SHOULD NOT, OPTIONAL, and MAY are to be interpreted as described in
[IETF RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

## Tech stack

- Bash, targeting Debian-based Linux (`apt`, `dpkg`).

- ShellCheck for static analysis.

## Project structure

- **`run/install`**: Entry script for full provisioning from scratch.
  Sources every install step in order.

- **`run/update`**: Entry script for updating an already-provisioned machine.
  Runs the shared step sequence (see `run/inc/fn/install-steps.sh`) but skips
  the first-time-only phases that `run/install` runs (system compatibility
  checks and base `util/*` installs).

- **`run/bootstrap`**: DEPRECATED. A thin wrapper that execs `run/install`,
  kept for machines/images pinned to older tags. New references MUST use
  `run/install` directly.

- **`run/inc/fn/`**: Shared helper functions (`print_step`, `step`, `superdo`,
  `is_gui_enabled`, status printers, banners) and `install-steps.sh`, which
  defines `run_install_steps` — the shared install/update step sequence that
  both entry scripts run.

- **`run/inc/var/`**: Shared variables (ANSI codes).

- **`run/inc/sys/`**: Compatibility checks, APT setup, system updates, upgrades, and teardown.

- **`run/inc/util/`**: General utilities (curl, git, gnupg, wget, …).

- **`run/inc/exec/`**: Language runtimes (Node, JDK, PHP, Python).

- **`run/inc/pkg/`**: Third-party APT repository registration.

- **`run/inc/web/`**: Web browsers.

- **`run/inc/app/`**: GUI/end-user applications.

- **`run/inc/dev/`**: Developer tooling (Claude, Copilot, delta, lazygit, …).

- **`run/inc/ops/`**: Ops tooling (AWS CLI, Terraform).

- **`run/inc/phy/`**: Hardware-related tooling (eg. ROCm).

- **`docs/`**: Installation, requirements, releasing, and considerations.

## Tools

- **`./run/install`** to provision a target machine from scratch (CLI tools
  only).

- **`./run/install --gui`** to additionally install GUI applications.

- **`./run/install --help`** to print the usage banner.

- **`./run/update`** to update an already-provisioned machine (CLI tools only).

- **`./run/update --gui`** to also update GUI applications.

- **`./run/update --help`** to print the usage banner.

- **`shellcheck run/**/*.sh run/install run/update`** to lint shell scripts.

## Feature toggles

CLI flags are parsed at the top of `run/install` and `run/update`, and
stored as global variables that any sourced install step can inspect via
helper predicates in `run/inc/fn/gui.sh`:

- **`--gui`** sets `install_gui=1`. Install steps that should only run with
  this flag must guard themselves with `is_gui_enabled || return 0`
  immediately before their `print_step` call.

Defaults are conservative: with no flags, only CLI tooling is installed.

`run/update` additionally sets `updating=1` (never set by `run/install`),
exposed via `is_updating`. Install steps must guard against `run/update`
performing package-manager work that's already covered, or a first-time
install of a tool that isn't wanted:

- Steps that only call `apt-get install`, with no extra config, must no-op
  entirely on update — the package is already kept current by the blanket
  `apt upgrade` in `sys/upgrade.sh`:

  ```bash
  is_updating && return 0
  print_step "Installing <apt-thing>"
  ...
  ```

- Steps using a non-APT install mechanism (npm, curl, GitHub releases, pipx,
  etc.) must never perform a first install on update — only upgrade a tool
  that's already present:

  ```bash
  print_step "Installing <thing>"
  if is_updating && ! command -v <thing> >/dev/null 2>&1; then
    return 0
  fi
  ...
  ```

## Rules

- MUST keep every script idempotent. Running `./run/install` repeatedly
  must converge, not duplicate, work.

- MUST call `print_step "…"` as the first non-comment line of every install
  step, so the run is self-narrating.

- MUST use the `superdo` helper instead of `sudo` directly, so scripts work
  both as root (eg. for Docker builds) and as a regular user (for local
  installs).

- MUST source every new install script from `run_install_steps` (in
  `run/inc/fn/install-steps.sh`) in the correct group, sorted alphabetically
  within that group, so it runs on both `./run/install` and `./run/update`.
  First-time-only steps (system checks, base `util/*` installs) are the
  exception and live inline in `run/install`.

- MUST target Debian-based distros only. Do not add steps that assume other
  package managers besides APT.

- MUST NOT commit ad-hoc one-off scripts to `run/inc/`. Each file installs
  or configures one named tool.

- SHOULD pin upstream versions when the project publishes stable tags or
  `.deb` artifacts, so devcontainer builds are reproducible.

- SHOULD restore the original working directory and clean up any temporary
  directories created during an install step.

- SHOULD add an "[Unreleased]" entry to `CHANGELOG.md` when adding,
  removing, or materially changing an install step.

## Skills

The following skills, scoped to this project, are installed in the
`./agents/skills/` directory:

- [**`./agents/skills/apt/SKILL.md`**](./skills/apt/SKILL.md):
  Use the APT package manager correctly in bootstrap scripts.

- [**`./agents/skills/install-step/SKILL.md`**](./skills/install-step/SKILL.md):
  Add or modify an install step in the bootstrap scripts.
