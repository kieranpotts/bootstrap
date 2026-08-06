---
name: install-step
description: Use this skill when adding a new tool to the bootstrap provisioning run, changing how an existing tool is installed, or removing one. Do NOT use this skill for one-off shell scripts that are not part of the bootstrap run, or for changes to `run/inc/fn/*.sh` (the shared helpers).
compatibility: requires bash, Debian-based Linux (apt/dpkg)
license: CC0-1.0
---

# Install step

The conventions defined in this skill keep `./run/install` idempotent,
readable, and reproducible across the host machine and the
[`docker-devcontainer`](https://hub.docker.com/r/kieranpotts/docker-devcontainer)
image.

## Input

Determine the following information from the surrounding context and
environment. You MUST NOT prompt the user for clarification on this task's
requirements. If you cannot determine the required inputs, stop and alert
the user with an error message.

- The tool to install, change, or remove — REQUIRED. The name of the
  program and whether it is being added, modified, or removed from the
  bootstrap run.

## Output

A new or modified install script under `run/inc/<group>/<name>.sh`, wired
into `run_install_steps` (in `run/inc/fn/install-steps.sh`) in the correct
group, with a changelog entry under `[Unreleased]` in `CHANGELOG.md` and
matching rows in `docs/tools.md` and `docs/drift.md`. The script passes
ShellCheck and smoke-tests cleanly on a clean target. Wiring it into
`run_install_steps` makes it run on both `./run/install` (full provisioning)
and `./run/update` (update passes).

This task runs non-interactively to completion. It does not block for user
input. If in doubt about any of the requirements of this task, stop and
print an error message.

## Instructions

1.  Pick the right group.

    Each install step lives in a single file under
    `run/inc/<group>/<name>.sh`. Pick the group that matches the tool's
    role:

    - `sys/`: System-level setup, upgrades, teardown.
    - `util/`: General command-line utilities (curl, wget, unzip, …).
    - `pkg/`: Third-party APT repository registration only.
    - `exec/`: Language runtimes and version managers.
    - `web/`: Web browsers.
    - `app/`: GUI/end-user applications.
    - `dev/`: Developer tooling (CLIs, TUIs, editors, linters).
    - `ops/`: Cloud and infrastructure CLIs.
    - `phy/`: Hardware-related tooling.

    Use the program's canonical short name as the filename (eg. `gh.sh`,
    not `github-cli.sh`).

2.  Create the install script from this template.

    ```bash
    #!/usr/bin/env bash

    #
    # Install <Program Name>.
    #
    # <Upstream homepage>
    # <Upstream install docs>
    #

    print_step "Installing <Program Name>."

    # Install commands here, using `superdo` instead of `sudo`.
    superdo apt-get install -y <package>
    ```

    The leading comment block is required. It documents what the script
    installs and points readers at the upstream install instructions.

3.  Wire the script into the step sequence.

    Add a line to `run_install_steps` in `run/inc/fn/install-steps.sh`, in
    the correct group, keeping the lines within that group sorted
    alphabetically. `run_install_steps` is the shared sequence that both
    `run/install` and `run/update` run, so a step added here automatically
    runs on fresh bootstraps and on update passes.

    The wrapper you call it with declares which profile the step belongs
    to. That choice _is_ the policy decision, and it is made here — never
    inside the step file. The profiles are cumulative
    (`agent` ⊆ `tui` ⊆ `gui`):

    - `tui_step` — the default. Tools that need a human at a terminal, but
      no display. Installed by a bare `./run/install`:

      ```bash
      tui_step "${inc_path}/<group>/<name>.sh" "<Program Name>"
      ```

      The second argument is the human-readable name shown in the prompt
      (`Install/update <Program Name>? (Y/n):`) — use the same name that
      follows "Installing " in the script's own `print_step` message.

    - `gui_step` — tools that need a display: applications, browsers,
      editors. Installed only by `./run/install --profile=gui`. Same
      arguments as `tui_step`.

    - `agent_step` — tools that belong in a minimal, unattended, headless
      container, and that the bootstrap therefore treats as
      non-negotiable. Called *without* a display name, so it never
      prompts:

      ```bash
      agent_step "${inc_path}/<group>/<name>.sh"
      ```

      Use it only if a coding agent genuinely needs the tool with no human
      present — not merely because most workstations want it. Anything
      needing a human at a terminal (TUIs, prompt cosmetics), a display, or
      physical hardware is not an agent tool. When in doubt use `tui_step`.

    - `step` — reserved for the `sys/*` plumbing that must run in every
      profile before anything else. Not for tools.

    Passing a display name is what makes a step prompt, independently of
    the profile. `pkg/*` registry steps are therefore called without one:
    they are plumbing, and run unannounced. Use `gui_step` for a registry
    whose packages are all `gui_step`s, so the other profiles do not
    register a repository they can never install from.

    Sort alphabetically by filename within the group regardless of which
    wrapper the line uses — do not group by wrapper.

    First-time-only steps (system compatibility checks in `sys/checks.sh`
    and base `util/*` installs) are the exception: they live inline in
    `run/install` rather than in `run_install_steps`, so `run/update`
    skips them.

4.  Resolve the upstream version at run time.

    Do not pin. APT steps take whatever the registry serves; npm globals
    install the current tag; steps installing from GitHub releases resolve
    the version with `gh_latest_tag` or `gh_asset_url` (see
    `run/inc/fn/gh-release.sh`), compare it against the installed version,
    and skip the download when they already match — see
    `run/inc/dev/lazygit.sh`.

    The reproducibility pin for the devcontainer image is the git tag on
    this repository, which fixes the install logic rather than the tool
    versions. Pin an individual version only to reproduce a specific build
    or dodge a known-bad upstream release, and say so in a comment beside
    the pin.

5.  Update the changelog.

    Add a one-line bullet under the `## [Unreleased]` heading in
    `CHANGELOG.md` describing the change (eg. `- Install GitHub CLI
    (\`gh\`).`).

6.  Update the documentation tables.

    Both are manually-maintained summaries that fall out of sync silently,
    so update them in the same change:

    - `docs/tools.md`: add, remove, or amend the program's row in the
      Agent/TUI/GUI table. The columns are cumulative, so a ✅ in one
      profile implies a ✅ in every profile to its right: `agent_step` is
      ✅ in all three, `tui_step` in TUI and GUI, `gui_step` in GUI only.
      Keep the table sorted by program name.

    - `docs/drift.md`: add or remove the program's row, recording whether
      the private `hacksltd` bootstrapper installs it too.

7.  Lint the script.

    Run `shellcheck -x --severity=warning` against the new or modified
    file (and `run/install` or `run/update` if either was touched) — the
    same threshold the ShellCheck workflow enforces. Resolve any findings
    before committing.

8.  Smoke-test the install.

    On a clean target – or by re-running `./run/install` on an
    existing host – confirm the new step prints its `STEP N` banner,
    completes without prompts, and that the installed binary is on
    `PATH` and reports a sensible version.

## Rules

- Scripts must be idempotent.

  `./run/install` and `./run/update` are both re-run to apply updates as
  well as on first provisioning. Each step must converge on the same end
  state whether it runs against a fresh machine or one that has been
  bootstrapped many times before.

  Prefer package-manager installs and guarded mutations
  (`grep -q … || echo … >> …`) over blind appends.

- Use `superdo`, never `sudo` directly.

  The `superdo` helper in `run/inc/fn/superdo.sh` invokes the command
  directly when running as root (Docker image builds) and prefixes
  `sudo` otherwise (local installs). Calling `sudo` directly breaks
  the Docker build path.

  ```bash
  # ✅ Yes:
  superdo apt-get install -y <package>

  # ❌ No:
  sudo apt-get install -y <package>
  ```

- Announce each step with `print_step`.

  The first non-comment line of every install script must be
  `print_step "Installing …."` (or an equivalent verb, ending in a full
  stop). The helper prints a numbered banner so the bootstrap run is
  self-narrating, and is the contract that downstream scripts depend on
  for step numbering.

- Never branch on the profile inside an install step.

  Profile membership is declared at the call site (step 3, above). An
  install step that is not in a profile is simply not called with that
  profile's wrapper — it does not check, and must not check, which profile
  is running. The predicates in `run/inc/fn/profile.sh` exist for the
  wrappers, not for step files:

  ```bash
  # ❌ No. This is what the call site is for.
  is_agent_profile && return 0

  # ✅ Yes. Nothing about the profile appears in the step file at all.
  print_step "Installing <thing>."
  ```

  The one predicate an install step does legitimately use is
  `is_updating` (below). `is_yes_enabled` and `profile_at_least` are
  consumed by the step wrappers themselves. `is_agent_profile` exists for
  the rare step that must know it is provisioning a headless container —
  eg. to skip a check that can only pass on real hardware — and is not a
  substitute for classifying the step correctly at the call site.

- Guard update runs against redundant or unwanted installs.

  `is_updating` (see above) must also be used to keep `run/update` from
  redoing work `apt upgrade` already covers, or installing a tool for the
  first time:

  - A step that only calls `apt-get install`, with no extra config, must
    no-op entirely on update, since `sys/upgrade.sh` already keeps the package
    current:

    ```bash
    # No-op on `./run/update`. Package is kept current by `apt upgrade`.
    is_updating && return 0

    print_step "Install <apt-thing>"
    # ...
    ```

  - A step using a non-APT mechanism (npm, curl, GitHub releases, pipx,
    etc.) must never perform a first install on update — only upgrade a
    tool that's already present:

    ```bash
    print_step "Install <thing>"

    # No-op on `./run/update`. Don't install new tools when updating.
    if is_updating && ! command -v <thing> >/dev/null 2>&1; then
      return 0
    fi
    # ...
    ```

- One tool per file.

  Do not bundle unrelated installs into a single script. If a tool
  genuinely depends on another, install the dependency in its own file
  and add both `step` lines to `run_install_steps` in the right order.

- Download into a temp directory; restore the working directory.

  When a step downloads tarballs or `.deb` files, create a temp
  directory with `mktemp -d`, capture the original working directory
  before `cd`-ing in, and `cd` back plus `rm -rf` the temp dir on the
  way out.

  See `run/inc/dev/lazygit.sh` and `run/inc/dev/delta.sh` for the
  established pattern.

- Target Debian-based Linux only.

  Use `apt-get`, `dpkg`, and `.deb` artifacts. Do not branch on
  distribution or add fallbacks for non-Debian systems. The supported
  environment is documented in `docs/requirements.md`.

- No interactive prompts.

  Pass `-y` to `apt-get install` and any other flag needed to keep the
  run non-interactive, so the script can complete unattended in Docker
  builds and CI.

- Print the installed version.

  Where the tool exposes `--version`, end the script with an `echo` of
  the installed version. This makes provisioning logs useful when
  diagnosing devcontainer build differences.

- Follow the project's shell conventions.

  `#!/usr/bin/env bash` shebang, two-space indent, lowercase snake-case
  for local variables, and `source` (already used throughout
  `run/install`). These match the existing style and `.shellcheckrc`
  configuration.

## Examples

A minimal install step backed by an apt package — see
[`run/inc/util/curl.sh`](../../run/inc/util/curl.sh):

```bash
#!/usr/bin/env bash

#
# Install Curl.
#
# Generally required for downloading files, including Debian packages.
#

print_step "Installing curl."

print_info "Installing/updating curl via APT."
superdo apt-get install -y curl

curl --version
```

An install step backed by a third-party apt source — see
[`run/inc/dev/gh.sh`](../../run/inc/dev/gh.sh). Registering the
repository is a separate `pkg/*` step, so the install step itself stays a
plain APT install that no-ops on update:

```bash
#!/usr/bin/env bash

#
# Install the GitHub CLI (`gh`).
#
# Depends on `pkg/github.sh` to set up package source in APT.
#
# https://github.com/cli/cli
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing GitHub CLI."

# Install the GitHub CLI.
superdo apt-get update
superdo apt-get install -y gh
gh --version
```

An install step that downloads a release tarball — see
[`run/inc/dev/lazygit.sh`](../../run/inc/dev/lazygit.sh) for the temp-dir
pattern, and for resolving the upstream version via the `gh_latest_tag`
helper in `run/inc/fn/gh-release.sh`.

## Edge cases

- Tools requiring a runtime: If the tool depends on Node, Python, or
  another runtime installed earlier in the run (eg. global npm packages
  like Claude Code or Copilot CLI), confirm that the runtime's `step` line
  in `run_install_steps` appears before the new step. Do not re-install the
  runtime inside the tool's script.

- Tools that modify `.bashrc`: Guard appends with a `grep -q` check so
  re-running the bootstrap does not duplicate exports. See
  `run/inc/exec/node.sh` for the established pattern.

- Removing a tool: Delete the install script, remove its `step` line
  from `run_install_steps` in `run/inc/fn/install-steps.sh`, drop its rows
  from `docs/tools.md` and `docs/drift.md`, and add an "[Unreleased]"
  changelog entry. Consider whether the bootstrap should
  also remove an already-installed copy on existing machines
  (`apt-get remove …`) — usually yes, so the cleanup converges on the new
  desired state.

## Success criteria

- The install script is idempotent — re-running `./run/install`
  converges, not duplicates.

- The script uses `superdo` instead of `sudo` directly.

- The first non-comment line is a `print_step` call.

- The script is wired into `run_install_steps` in `run/inc/fn/install-steps.sh`
  in the correct group, alphabetically sorted, via the wrapper for the
  profile it belongs to — `agent_step`, `tui_step`, or `gui_step` — with a
  display name unless it is plumbing.

- The script contains no reference to the profile. Membership lives at the
  call site only.

- The script guards against redundant or unwanted work on `./run/update`
  (`is_updating`, as above).

- The script passes `shellcheck -x --severity=warning` with no findings.

- A changelog entry has been added under `[Unreleased]`, and
  `docs/tools.md` and `docs/drift.md` have matching rows.

## References

- [`./AGENTS.md`](../../AGENTS.md): Project-level rules this skill
  builds on.

- [`run/inc/fn/steps.sh`](../../run/inc/fn/steps.sh): Source of `print_step`,
  `step`, `profile_step`, and the `agent_step`/`tui_step`/`gui_step`
  wrappers.

- [`run/inc/fn/superdo.sh`](../../run/inc/fn/superdo.sh): Source of `superdo`.

- [`run/inc/fn/profile.sh`](../../run/inc/fn/profile.sh): Source of
  `profile_at_least`, `is_agent_profile`, `is_updating`, and
  `is_yes_enabled`.

- [`run/inc/fn/install-steps.sh`](../../run/inc/fn/install-steps.sh): The
  shared `run_install_steps` sequence that new steps are wired into.

- [`docs/installation.md`](../../docs/installation.md): How the entry
  scripts are invoked, and the install profiles they support.

- [`docs/tools.md`](../../docs/tools.md): Which profile installs which
  program — the table every new step must be added to.
