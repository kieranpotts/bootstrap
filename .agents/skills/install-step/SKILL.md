---
name: install-step
description: >-
  Add, change, or remove a tool in the bootstrap provisioning run, including
  its step file, its wiring into the shared step sequence, and the changelog
  and documentation rows that go with it. Use when the user says "add <tool>
  to the bootstrap", "install <tool> on new machines", "move <tool> to the
  gui profile", or "drop <tool> from the bootstrap". Do not use it for
  one-off shell scripts outside the bootstrap run, or for changes to the
  shared helpers in `run/inc/fn/`.
compatibility: >-
  requires Read, Write, Edit, Glob, Grep,
  Bash (shellcheck, apt-get, dpkg, ./run/install)
license: CC0-1.0
---

# Install step

Add, change, or remove one tool in the bootstrap provisioning run, keeping
`./run/install` idempotent, readable, and reproducible across a host machine
and the
[`docker-devcontainer`](https://hub.docker.com/r/kieranpotts/docker-devcontainer)
image. Do not modify the shared helpers under `run/inc/fn/`, beyond the one
line that wires a step into `run_install_steps`.

## Parameters

Determine the following information from the surrounding context and
environment. You MUST NOT prompt the user for clarification on this task's
requirements. If you cannot determine the requirements, stop and alert the
user with an error message.

- **The tool — REQUIRED.** The program being added, changed, or removed,
  named by its canonical short name — the name of its executable, eg. `gh`
  rather than `github-cli`.

- **The operation — REQUIRED.** Whether the tool is being added, modified,
  or removed.

- **The install profile — OPTIONAL.** Which of `cli`, `tui`, or `gui` the
  step belongs to. Default to `tui`. For an existing tool, read the current
  profile from its call in `run/inc/fn/install-steps.sh`.

- **The install mechanism — OPTIONAL.** APT, npm, a GitHub release, a
  downloaded `.deb`, or an upstream install script. Infer it from the
  upstream project's own install documentation, preferring APT where the
  tool is packaged for Debian.

## Success criteria

- A single step file MUST exist at `run/inc/<group>/<name>.sh`, installing
  exactly one named tool.

- The step MUST converge rather than duplicate when `./run/install` is run
  a second time against an already-provisioned machine.

- The step MUST be called from `run_install_steps` in
  `run/inc/fn/install-steps.sh`, in the correct group, sorted
  alphabetically by filename within that group, through the wrapper for its
  profile.

- The step file MUST contain no reference to the install profile. Profile
  membership is readable from the call site alone.

- `shellcheck -x --severity=warning` MUST report no findings against the
  step file, and against `run/install` if it was touched.

- `CHANGELOG.md` SHOULD carry a new bullet under `## [Unreleased]`, and
  `docs/tools.md` and `NOTES.md` SHOULD each carry a matching row.
  These are hand-maintained summaries, so a change that skips them drifts
  silently.

- The shared helpers under `run/inc/fn/` MUST be unchanged apart from the
  one line in `install-steps.sh`. Behavior belongs to the helpers; this
  skill only adds callers.

## Instructions

1.  Pick the group.

    Each install step lives in a single file under
    `run/inc/<group>/<name>.sh`. Pick the group matching the tool's role:

    - `sys/`: System-level setup, upgrades, teardown.
    - `util/`: General command-line utilities (curl, wget, unzip, …).
    - `pkg/`: Third-party APT repository registration only.
    - `exec/`: Language runtimes and version managers.
    - `web/`: Web browsers.
    - `app/`: GUI/end-user applications.
    - `dev/`: Developer tooling (CLIs, TUIs, editors, linters).
    - `ops/`: Cloud and infrastructure CLIs.
    - `phy/`: Hardware-related tooling.

    Use the program's canonical short name as the filename.

2.  Create the step file from this template.

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

    The leading comment block is REQUIRED. It records what the script
    installs and points a reader at the upstream install instructions,
    which is the only trail back to why a step is written as it is.

3.  Wire the step into the sequence.

    Add one line to `run_install_steps` in `run/inc/fn/install-steps.sh`,
    in the correct group. `run_install_steps` is the shared sequence that
    `run/install` runs on both a fresh bootstrap and a re-run against an
    already-provisioned machine.

    The wrapper you call it with declares the profile the step belongs to.
    That choice is the policy decision, and it MUST be made here, never
    inside the step file. The profiles are cumulative
    (`cli` ⊆ `tui` ⊆ `gui`):

    - `tui_step` — the safe default choice when unsure. Tools needing a
      human at a terminal but no display. Installed by
      `./run/install --profile=tui`:

      ```bash
      tui_step "${inc_path}/<group>/<name>.sh"
      ```

    - `gui_step` — tools needing a display: applications, browsers,
      graphical editors. Installed only by `./run/install --profile=gui`.
      Same arguments as `tui_step`.

    - `cli_step` — tools belonging in a minimal, unattended, headless
      container, which the bootstrap therefore treats as non-negotiable:

      ```bash
      cli_step "${inc_path}/<group>/<name>.sh"
      ```

      Use it only where a coding agent genuinely needs the tool with no
      human present — not merely because most workstations want it.
      Anything needing a human at a terminal (TUIs, prompt cosmetics), a
      display, or physical hardware is not an agent tool. When in doubt,
      use `tui_step`.

    - `step` — reserved for the `sys/*` plumbing that MUST run in every
      profile before anything else. Not for tools.

    Sort alphabetically by filename within the group regardless of which
    wrapper the line uses. Do not group by wrapper.

4.  Resolve the upstream version at run time.

    You SHOULD NOT pin. APT steps take whatever the registry serves, npm globals
    install the current tag, and steps installing from GitHub releases
    resolve the version with `gh_latest_tag` or `gh_asset_url` (see
    `run/inc/fn/gh-release.sh`), compare it against the installed version,
    and skip the download when they already match. Follow
    `run/inc/dev/lazygit.sh` for that pattern.

5.  Update the changelog.

    Add a one-line bullet under the `## [Unreleased]` heading in
    `CHANGELOG.md` describing the change, eg. `- Install GitHub CLI
    (\`gh\`).`

6.  Update the documentation tables.

    Both are maintained by hand and fall out of sync silently, so update
    them in the same change:

    - `docs/tools.md`: add, remove, or amend the program's row in the
      CLI/TUI/GUI table. The columns are cumulative, so a ✅ in one
      profile implies a ✅ in every profile to its right: `cli_step` is
      ✅ in all three, `tui_step` in TUI and GUI, `gui_step` in GUI only.
      Keep the table sorted by program name.

    - `NOTES.md`: add or remove the program's row, recording whether
      the private `hacksltd` bootstrapper installs it too.

7.  Lint the script.

    Run ShellCheck against the new or modified file, and against
    `run/install` if it was touched, at the same threshold the CI workflow
    enforces:

    ```sh
    shellcheck -x --severity=warning run/inc/<group>/<name>.sh
    ```

    Resolve every finding before finishing.

8.  Smoke-test the install.

    On a clean target, or by re-running `./run/install` on an existing
    host, confirm the step prints its `STEP N` banner, completes
    unattended, and leaves the installed binary on `PATH` reporting a
    sensible version. Where no clean target is available, say so in your
    summary rather than claiming the step was tested.

## Rules

- Each step MUST be idempotent.

  `./run/install` is re-run to apply updates, not only on first
  provisioning. Each step MUST converge on the same end state whether it
  runs against a fresh machine or one bootstrapped many times before.
  Prefer package-manager installs and guarded mutations
  (`grep -q … || echo … >> …`) over blind appends.

- You MUST use `superdo` rather than `sudo` directly.

  The `superdo` helper in `run/inc/fn/superdo.sh` invokes the command
  directly when running as root (Docker image builds) and prefixes `sudo`
  otherwise (local installs). Calling `sudo` directly breaks the Docker
  build path.

  ```bash
  # ✅ Yes:
  superdo apt-get install -y <package>

  # ❌ No:
  sudo apt-get install -y <package>
  ```

- The first non-comment line of every step file MUST be a `print_step`
  call, worded as `print_step "Installing …."` or an equivalent verb,
  ending in a full stop.

  The helper prints a numbered banner, so the run narrates itself, and step
  numbering is a contract downstream scripts depend on.

- A step file MUST NOT branch on the install profile.

  Profile membership is declared at the call site. A step that does not
  belong in a profile is simply not called with that profile's wrapper; it
  does not check, and MUST NOT check, which profile is running.

  ```bash
  # ❌ No. This is what the call site is for.
  is_cli_profile && return 0

  # ✅ Yes. Nothing about the profile appears in the step file at all.
  print_step "Installing <thing>."
  ```

  `profile_at_least` is consumed by the wrappers, not by step files.

- Each file MUST install exactly one tool.

  Where a tool genuinely depends on another, install the dependency in its
  own file and add both calls to `run_install_steps` in the right order.

- A step that downloads an archive or a `.deb` SHOULD work in a temporary
  directory and restore the original working directory.

  Create the directory with `mktemp -d`, capture the working directory
  before `cd`-ing in, then `cd` back and `rm -rf` the temporary directory
  on the way out. See `run/inc/dev/lazygit.sh` and `run/inc/dev/delta.sh`
  for the established pattern.

- Steps MUST target Debian-based Linux only.

  Use `apt-get`, `dpkg`, and `.deb` artifacts. Do not branch on
  distribution or add fallbacks for other package managers. The supported
  environment is recorded in `docs/requirements.md`.

- Steps MUST NOT prompt.

  Pass `-y` to `apt-get install` and whatever equivalent flag another
  installer needs, so the run completes unattended in Docker builds and CI.

- A step SHOULD end by echoing the installed version, where the tool
  exposes `--version`. It makes provisioning logs useful when diagnosing
  differences between devcontainer builds.

- Steps MUST follow the project's shell conventions: an
  `#!/usr/bin/env bash` shebang, two-space indentation, lowercase
  snake-case local variables, and `source` rather than `.`. These match the
  existing style and the `.shellcheckrc` configuration.

## Edge cases

- The tool depends on a language runtime.

  Where the tool needs Node, Python, or another runtime installed earlier
  in the run — a global npm package, say — confirm that the runtime's call
  in `run_install_steps` precedes the new one. Do not re-install the
  runtime inside the tool's own step file.

- The tool modifies `.bashrc`.

  Guard the append with a `grep -q` check, so re-running the bootstrap does
  not duplicate exports. See `run/inc/exec/node.sh` for the pattern.

- The tool needs a third-party APT repository.

  Register the repository in its own `pkg/*` step, and keep the install
  itself a plain APT step. Where every package that registry serves is a
  `gui_step`, call the registry with `gui_step` too, so the other profiles
  do not register a repository they can never install from.

- The tool is being removed.

  Delete the step file, remove its call from `run_install_steps`, drop its
  rows from `docs/tools.md` and `NOTES.md`, and add an `[Unreleased]`
  changelog entry. Consider whether the bootstrap SHOULD also remove an
  already-installed copy from existing machines (`apt-get remove -y …`) —
  usually yes, so that existing machines converge on the new desired state.

- The step must run only on first provisioning.

  System compatibility checks (`sys/checks.sh`) and the base `util/*`
  installs live inline in `run/install`, ahead of `run_install_steps`,
  rather than as steps in the shared sequence. Add to that inline sequence
  only for genuine first-run plumbing.

## Examples

- A minimal step backed by an APT package — see
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

- A step backed by a third-party APT source — see
  [`run/inc/dev/gh.sh`](../../run/inc/dev/gh.sh). Registering the
  repository is a separate `pkg/*` step, so the install step itself stays
  a plain APT install:

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

  print_step "Installing GitHub CLI."

  # Install the GitHub CLI.
  superdo apt-get update
  superdo apt-get install -y gh
  gh --version
  ```

- A step that downloads a release tarball — see
  [`run/inc/dev/lazygit.sh`](../../run/inc/dev/lazygit.sh) for the
  temporary-directory pattern, and for resolving the upstream version with
  the `gh_latest_tag` helper.

## References

- [`AGENTS.md`](../../AGENTS.md) \
  Read for the project-level rules this skill builds on.

- [`run/inc/fn/steps.sh`](../../run/inc/fn/steps.sh) \
  Read for the source of `print_step`, `step`, and the
  `cli_step`/`tui_step`/`gui_step` wrappers.

- [`run/inc/fn/profile.sh`](../../run/inc/fn/profile.sh) \
  Read when you need the exact semantics of `profile_at_least` or
  `is_cli_profile`.

- [`run/inc/fn/install-steps.sh`](../../run/inc/fn/install-steps.sh) \
  Read before wiring a step in, to find the group and the alphabetical
  position for the new call.

- [`run/inc/fn/gh-release.sh`](../../run/inc/fn/gh-release.sh) \
  Read when the tool installs from a GitHub release rather than from APT.

- [`docs/installation.md`](../../docs/installation.md) \
  Read for how the entry scripts are invoked and the profiles they accept.

- [`docs/tools.md`](../../docs/tools.md) \
  Read to find the row a new step must add, and the profile columns it
  must fill.
