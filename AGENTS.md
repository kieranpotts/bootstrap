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

- **`run/install`**: Entry script for provisioning a machine from scratch,
  or re-running to pick up updates. Sources every install step in order.

- **`run/bootstrap`**: DEPRECATED. A thin wrapper that execs `run/install`,
  kept for machines/images pinned to older tags. New references MUST use
  `run/install` directly.

- **`run/inc/fn/`**: Shared helper functions (`print_step`, `step`, the
  `agent_step`/`tui_step`/`gui_step` profile wrappers, `superdo`, status
  printers, banners), `profile.sh` (the profile predicates and runtime
  toggles), and `install-steps.sh`, which defines `run_install_steps` — the
  shared install step sequence.

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

- **`./run/install`** to provision a target machine from scratch, in the
  default `tui` profile.

- **`./run/install --profile=agent`** for the minimal tooling a coding agent
  needs in a headless container, or **`--profile=gui`** for the full
  workstation install. See `docs/tools.md`.

- **`./run/install --yes`** (or **`-y`**) to skip the per-tool
  install/update prompts and assume yes to all of them.

- **`./run/install --help`** to print the usage banner.

- **`shellcheck -x --severity=warning run/**/*.sh run/install`**
  to lint shell scripts, at the same threshold CI enforces.

- **`ec`** (editorconfig-checker) to validate files against `.editorconfig`.
  Configured by `.editorconfig-checker.json`, which disables only the
  IndentSize check.

- **`codespell --skip='./.git'`** to check for common misspellings.

  All three run in CI on every push — see `.github/workflows/`.

## Install profiles

`--profile` is the only axis controlling *what* gets installed. It answers
"who is driving this machine?", and the three answers are cumulative —
`agent` ⊆ `tui` ⊆ `gui`:

- **`agent`** — nobody. A headless container running coding agents, eg.
  `docker-devcontainer`. No human to prompt, no display.
- **`tui`** — a human at a terminal, with no display. **The default.**
- **`gui`** — a human at a desktop. The full workstation install.

`tui` names the *environment*, not the shape of the tools: that profile holds
plenty of non-interactive CLIs (`aws`, `ffmpeg`, `terraform`) alongside actual
terminal UIs.

Profile membership is declared **at the call site** in
`run/inc/fn/install-steps.sh`, via `agent_step`, `tui_step`, or `gui_step` —
never by a guard inside a step file. That keeps "what does this profile
install?" answerable by reading one file, and it is why `run/inc/fn/steps.sh`
has three wrappers rather than one. `docs/tools.md` is the rendered summary.

A second, independent rule governs prompting: a call that passes a display
name is a discrete tool and prompts before running; a call without one is
plumbing and runs unannounced. The prompt defaults to yes, and is skipped
entirely — the step still runs — when `--yes`/`-y` was passed
(`is_yes_enabled`) or stdin is not a terminal (piped output, `docker build`,
CI). Steps outside the selected profile are skipped silently, without a
prompt.

The predicates behind all of this live in `run/inc/fn/profile.sh`:
`profile_at_least` (used by the wrappers), `is_agent_profile`, and
`is_yes_enabled`. An unrecognised `--profile=<value>` is rejected at parse
time. There is no `--gui` flag; it was replaced by `--profile=gui`, and
passing it now exits with an error pointing at the replacement.

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
  within that group. First-time-only steps (system checks, base `util/*`
  installs) are the exception and live inline in `run/install`. Alphabetical
  order is by filename regardless of which wrapper the call uses — do not
  group by profile.

- MUST declare profile membership at the call site, never inside a step
  file. An install step MUST NOT branch on the profile to decide whether it
  runs at all: if it does not belong in a profile, it is simply not called
  with that profile's wrapper.

  A step MAY still call `is_agent_profile` to adjust its own behavior once
  it is already running — eg. skipping a check that can only pass on real
  hardware, inside a step shared across every profile via `agent_step`.
  This is the rare exception, not membership by another name: the step
  still runs in every profile either way, only what it does once running
  changes.

- MUST use `agent_step` only for a step that belongs in a minimal,
  unattended, headless coding agent container — not merely "something most
  workstations want". `tui_step` is the safe default. Use `gui_step` when
  the tool needs a display. Update `docs/tools.md` to match whichever you
  choose.

- MUST call a `pkg/*` registry via `gui_step` when every package that
  registry serves is itself a `gui_step`. Registering a repository the run
  can never install from only slows down `apt update` and adds a key to the
  machine (or image) for nothing.

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
  install step (moving it between `agent_step`, `tui_step`, and `gui_step`),
  so the Agent/TUI/GUI table stays a trustworthy summary of
  `run_install_steps`.

## Skills

The following skills, scoped to this project, are installed in the
`.agents/skills/` directory:

- [**`.agents/skills/apt/SKILL.md`**](./.agents/skills/apt/SKILL.md):
  Use the APT package manager correctly in bootstrap scripts.

- [**`.agents/skills/install-step/SKILL.md`**](./.agents/skills/install-step/SKILL.md):
  Add or modify an install step in the bootstrap scripts.
