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

- **`run/inc/fn/`**: Shared helper functions (`print_step`, `step`,
  `core_step`, `confirm_step`, `superdo`, `is_gui_enabled`,
  `is_agent_profile`, status printers, banners) and `install-steps.sh`,
  which defines `run_install_steps` — the shared install/update step
  sequence that both entry scripts run.

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

- **`docs/`**: Installation, requirements, tools (what installs under each
  profile), releasing, considerations, drift (vs. the private `hacksltd`
  bootstrapper), and architecture decision records (`docs/adr/`).

## Tools

- **`./run/install`** to provision a target machine from scratch (CLI tools
  only).

- **`./run/install --gui`** to additionally install GUI applications.

- **`./run/install --yes`** (or **`-y`**) to skip the per-tool
  install/update prompts and assume yes to all of them.

- **`./run/install --profile=agent`** to install only the `core_step` set —
  the minimal tooling a coding agent needs in a headless container. See
  `docs/tools.md`.

- **`./run/install --help`** to print the usage banner.

- **`./run/update`** to update an already-provisioned machine (CLI tools only).

- **`./run/update --gui`** to also update GUI applications.

- **`./run/update --yes`** (or **`-y`**) to skip the per-tool prompts.

- **`./run/update --profile=agent`** to update only the `core_step` set.

- **`./run/update --help`** to print the usage banner.

- **`shellcheck -x --severity=warning run/**/*.sh run/install run/update`**
  to lint shell scripts, at the same threshold CI enforces.

- **`ec`** (editorconfig-checker) to validate files against `.editorconfig`.
  Configured by `.editorconfig-checker.json`, which disables only the
  IndentSize check.

- **`codespell --skip='./.git'`** to check for common misspellings.

  All three run in CI on every push — see `.github/workflows/`.

## Feature toggles

CLI flags are parsed at the top of `run/install` and `run/update`, and
stored as global variables that any sourced install step can inspect via
helper predicates in `run/inc/fn/gui.sh`:

- **`--gui`** sets `install_gui=1`. Install steps that should only run with
  this flag must guard themselves with `is_gui_enabled || return 0`
  immediately before their `print_step` call.

- **`--yes`/`-y`** sets `assume_yes=1`, exposed via `is_yes_enabled`.
  Consumed by `confirm_step` (see `run/inc/fn/steps.sh`), which wraps
  `step` with a per-tool `Install/update <name>? (Y/n):` prompt for the
  `web/*`, `app/*`, `dev/*`, `ops/*`, and `phy/*` groups in
  `run_install_steps`. The prompt defaults to yes and is skipped
  entirely — the step always runs — when `--yes` was passed or stdin
  is not a terminal (piped output, `docker build`, CI).

- **`--profile=agent`** sets `profile="agent"`, exposed via
  `is_agent_profile`. Consumed by `confirm_step`, which skips its step
  outright (no prompt, no fallback) whenever the agent profile is active.
  The resulting install is exactly the `core_step` set, plus the always-on
  `sys/*`/`util/*`/`pkg/*` plumbing. Intended for headless containers (eg.
  `docker-devcontainer`) where there is no human to prompt and no display.
  Any other `--profile=<value>` is rejected as an unknown argument.

Defaults are conservative: with no flags, only CLI tooling is installed
(with a confirmation prompt per tool).

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
  exception and live inline in `run/install`. Alphabetical order is by
  filename regardless of whether the call uses `core_step` or
  `confirm_step` — do not group by step type.

- MUST call a `web/*`, `app/*`, `dev/*`, `ops/*`, or `phy/*` step via
  `core_step` only if it belongs in a minimal, unattended, headless coding
  agent container — not merely "something most workstations want". When in
  doubt, use `confirm_step`: it is the safe default, and still installs
  unprompted on any non-interactive `./run/install` run outside the agent
  profile (`docker build`, CI, `--yes`). Update `docs/tools.md` to match
  whichever you choose.

- MUST guard a `pkg/*` registry step with `is_gui_enabled || return 0` when
  every package that registry serves is installed by a GUI-gated step.
  Registering a repository the run can never install from only slows down
  `apt update` and adds a key to the machine (or image) for nothing.

- MUST target Debian-based distros only. Do not add steps that assume other
  package managers besides APT.

- MUST NOT commit ad-hoc one-off scripts to `run/inc/`. Each file installs
  or configures one named tool.

- SHOULD resolve upstream versions at run time, not pin them. Steps that
  install from GitHub releases use `gh_latest_tag`/`gh_asset_url` (see
  `run/inc/fn/gh-release.sh`), APT steps take whatever the registry serves,
  and npm globals install the current tag. Re-running the bootstrap is
  therefore how a machine gets upgraded, and two builds of the same
  bootstrap tag are not byte-identical.

  The reproducibility pin is the git tag on *this* repository, which fixes
  the install *logic* — `docker-devcontainer` builds against a tag, not
  against `latest/dev`. Pin an individual upstream version only when a
  specific build has to be reproduced exactly, or when a known-bad upstream
  release has to be avoided, and record why in a comment beside the pin.

- SHOULD restore the original working directory and clean up any temporary
  directories created during an install step.

- SHOULD add an "[Unreleased]" entry to `CHANGELOG.md` when adding,
  removing, or materially changing an install step.

- SHOULD add a row to `docs/drift.md` when adding or removing an install
  step, so the comparison against the private `hacksltd` bootstrapper
  doesn't fall out of sync.

- SHOULD update `docs/tools.md` when adding, removing, or reclassifying an
  install step (`step`/`core_step`/`confirm_step`, or adding/removing an
  `is_gui_enabled` guard), so the Agent/CLI/GUI table stays a trustworthy
  summary of `run_install_steps`.

## Skills

The following skills, scoped to this project, are installed in the
`.agents/skills/` directory:

- [**`.agents/skills/apt/SKILL.md`**](./.agents/skills/apt/SKILL.md):
  Use the APT package manager correctly in bootstrap scripts.

- [**`.agents/skills/install-step/SKILL.md`**](./.agents/skills/install-step/SKILL.md):
  Add or modify an install step in the bootstrap scripts.
