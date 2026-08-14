---
name: bootstrap-program
description: >-
  Add, change, or remove a program in the bootstrap provisioning run. Use this 
  skill when the user says something like "add <program> to the bootstrap", 
  "install <program> on new machines", "move <program> to the gui profile", 
  "drop <program> from the bootstrap", "install <package> via apt", 
  "check this apt command", or asks why a package step is prompting or 
  failing on a fresh machine. Do not use it for one-off shell scripts 
  outside the bootstrap run, to run one-off package operations against the
  current machine outside a bootstrap script, or to make local changes to 
  individual parts of the shell scripts such as the shared helpers in 
  `run/inc/fn/`.
compatibility: >-
  requires Read, Write, Edit, Glob, Grep,
  Bash (shellcheck, apt-get, apt-cache, dpkg, ./run/install)
license: CC0-1.0
---

# Bootstrap program

Add, change, or remove one program in the bootstrap provisioning run, keeping
`./run/install` idempotent, readable, and reproducible across a host machine. 
Do not modify the shared helpers under `run/inc/fn/`, beyond the one line that 
wires a step into `run_install_steps`.

## Parameters

Determine the following information from the surrounding context and
environment first. You MAY prompt the user to confirm any individual
parameter that you cannot determine from context or environment — eg. an
ambiguous program name, or a profile you cannot classify from upstream
documentation. But do not prompt for a parameter you can resolve yourself.

- **The program — REQUIRED.** The program being added, changed, or removed,
  named by its canonical short name — the name of its executable, eg. `gh`
  rather than `github-cli`.

- **The operation — REQUIRED.** Whether the program is being added, modified,
  or removed.

- **The install profile — REQUIRED for adding, OPTIONAL for changing/removing.**
  Which of `cli`, `tui`, or `gui` the step belongs to. Unless made explicit
  in the user's own prompt, try to determine the profile yourself — see the
  instructions, below.

- **The install mechanism — OPTIONAL.** eg. APT, NPM, a GitHub release, a
  downloaded `.deb`, or an upstream install script. If not specified by the
  user, infer the best installation mechanism from the upstream project's own 
  install documentation. Prefer APT where the program is packaged for Debian.

## Success criteria

- A single step file MUST exist at `run/inc/<group>/<name>.sh`, installing
  exactly one named program.

- The step MUST converge rather than duplicate when `./run/install` is run
  a second time against an already-provisioned machine.

- The step MUST be called from `run_install_steps` in
  `run/inc/fn/install-steps.sh`, in the correct group, sorted
  alphabetically by filename within that group, through the wrapper for its
  profile.

- The step file MUST contain no reference to the install profile. Profile
  membership is readable from the call site alone.

- Every APT invocation in the step MUST call `apt-get`, never `apt`, MUST
  pass `-y` on every mutating call, and MUST be prefixed with `superdo`.
  An `apt-get update` MUST precede the first install that draws on a source
  the same change added.

- `shellcheck -x --severity=warning` MUST report no findings against the
  step file, and against `run/install` if it was touched.

- `CHANGELOG.md` SHOULD carry a new bullet under `## [Unreleased]`, and
  the `## 💻 Programs` table in `README.md` and the drift table in
  `NOTES.md` SHOULD each carry a matching row.

- The shared helpers under `run/inc/fn/` MUST be unchanged apart from the
  one line in `install-steps.sh`. Behavior belongs to the helpers.

## Instructions

1.  Deterine the target profile: `cli`, `tui`, or `gui`.

  - For an existing program that's being updated or deleted, read the current 
    profile from its call in `run/inc/fn/install-steps.sh`.

  - For a new program being installed for the first time, classify it from what 
    the program is. Consult the upstream project's homepage and install 
    documentation, and the program's man page where one exists (`man <program>`, 
    or the online equivalent), to learn whether it is a headless CLI, a terminal 
    UI, or a graphical application.

2.  Pick the group. Each install step lives in a single file under
    `run/inc/<group>/<name>.sh`. Pick the group matching the program's role:

    - `sys/` for system-level setup, upgrades, teardown.
    - `util/` for general command-line utilities (curl, wget, unzip, …).
    - `pkg/` for third-party APT repository registration only.
    - `exec/` for language runtimes and version managers.
    - `web/` for web browsers.
    - `app/` for GUI/end-user applications.
    - `dev/` for developer tooling (CLIs, TUIs, editors, linters).
    - `ops/` for cloud and infrastructure CLIs.
    - `phy/` for hardware-related utils.

    Use the program's canonical short name as the filename.

3.  Create the step file. Start with an `#!/usr/bin/env bash` shebang,
    then a REQUIRED leading comment block recording what the script installs
    and pointing at the upstream install docs — the only trail back to why a
    step is written as it is. The first non-comment line MUST be the
    `print_step "Installing <Program Name>."` call. See the **Examples**
    section below for complete files to copy as a starting point.

4.  Wire the step into the sequence. Add one line to `run_install_steps` in 
    `run/inc/fn/install-steps.sh`, in the correct group. `run_install_steps` is 
    the shared sequence that `run/install` runs on both a fresh bootstrap and 
    a re-run against an already-provisioned machine.

    The wrapper you call it with declares the profile the step belongs to.
    That choice is the policy decision, and it MUST be made here, never
    inside the step file. The profiles are cumulative
    (`cli` ⊆ `tui` ⊆ `gui`):

    - `tui_step`. Programs needing a human at a terminal but no display.
      Installed by `./run/install --profile=tui`.

      ```bash
      tui_step "${inc_path}/<group>/<name>.sh"
      ```

    - `gui_step`. Programs needing a display: applications, browsers,
      graphical editors. Installed only by `./run/install --profile=gui`.

      ```bash
      gui_step "${inc_path}/<group>/<name>.sh"
      ```

    - `cli_step`. The minimal tooling a coding agent needs to work
      unattended in a headless container — what the bootstrap treats as
      non-negotiable. This is the home of general CLI utilities (`curl`,
      `less`, `lsof`, `ping`), core dev tooling (`gh`, `git-lfs`, `vim`,
      `tmux`, `shellcheck`), and anything else a headless container must
      have. But a terminal UI is not disqualifying — eg. `tmux` and `vim` are
      `cli_step`s because an agent may drive them programmatically.

      ```bash
      cli_step "${inc_path}/<group>/<name>.sh"
      ```

      Reach for `tui_step` or `gui_step` only when the tool genuinely needs
      a human or a display and is not core to a headless container.
      `tui_step` for terminal-only tools. `gui_step` for desktop programs.

    - `step`. Runs unconditionally in every profile, with no filtering.
      Reserved for plumbing that must always run: the `sys/*` setup,
      update, upgrade, and teardown steps, and `pkg/*` registries that
      serve `cli_step` packages (eg. `pkg/github.sh`, `pkg/git-lfs.sh`).
      It is not for the installation of programs themselves.

    Sort alphabetically by filename within the group regardless of which
    wrapper the line uses. Do not group by wrapper.

5.  Resolve the upstream version at run time. You SHOULD NOT pin. APT steps take 
    whatever the registry serves, NPM globals install the current tag, and steps 
    installing from GitHub releases resolve the version with `gh_latest_tag` 
    or `gh_asset_url`, compare it against the installed version, and skip the 
    download when they already match.

6.  Update the changelog. Add a one-line bullet under the `## [Unreleased]` 
    heading in `CHANGELOG.md` describing the change, eg. 
    `` - Install GitHub CLI (\`gh\`). ``

7.  Update the documentation tables. Both are maintained by hand and fall out
    of sync silently, so update them in the same change.

    - `README.md` (`## 💻 Programs`). Add, remove, or amend the program's
      row in the CLI/TUI/GUI table. The columns are cumulative, so a ✅ in
      one profile implies a ✅ in every profile to its right: `cli_step`
      is ✅ in all three, `tui_step` in TUI and GUI, `gui_step` in GUI
      only. Keep the table sorted by program name.

    - `NOTES.md`. Add or remove the program's row, recording whether
      the private `hacksltd` bootstrapper installs it too.

8.  Lint the script. Run ShellCheck against the new or modified file, and against
    `run/install` if it was touched, at the same threshold the CI workflow
    enforces.

    ```sh
    shellcheck -x --severity=warning run/inc/<group>/<name>.sh
    ```

    Resolve every finding before finishing.

9.  Smoke-test the install. On a clean target, or by re-running `./run/install` 
    on an existing host, confirm the step prints its `STEP N` banner, completes
    unattended, and leaves the installed binary on `PATH` reporting a
    sensible version. Where no clean target is available, say so in your
    summary rather than claiming the step was tested.

## Rules

- Each step MUST be idempotent. `./run/install` is re-run to apply updates, not 
  only on first provisioning. Each step MUST converge on the same end state 
  whether it runs against a fresh machine or one bootstrapped many times before.
  Prefer package-manager installs and guarded mutations
  (`grep -q … || echo … >> …`) over blind appends.

- You MUST use `superdo` rather than `sudo` directly. The `superdo` helper in 
  `run/inc/fn/superdo.sh` invokes the command directly when running as root 
  (Docker image builds) and prefixes `sudo` otherwise (local installs). Calling 
  `sudo` directly breaks the Docker build path.

  ```bash
  # ✅ Yes:
  superdo apt-get install -y <package>

  # ❌ No:
  sudo apt-get install -y <package>
  ```

- The first non-comment line of every step file MUST be a `print_step`
  call, worded as `print_step "Installing …."` or an equivalent verb,
  ending in a full stop.

  `print_step` increments the run's step counter and prints a numbered
  banner, so the run narrates itself. A step that omits it, or calls it
  more than once, breaks the displayed sequence. So every step MUST call
  it exactly once, as its first non-comment line.

- A step file MUST NOT branch on the install profile. Profile membership is 
  declared at the call site. A step that does not belong in a profile is simply 
  not called with that profile's wrapper; it does not check, and MUST NOT check, 
  which profile is running.

  ```bash
  # ❌ No. This is what the call site is for.
  is_cli_profile && return 0

  # ✅ Yes. Nothing about the profile appears in the step file at all.
  print_step "Installing <thing>."
  ```

  `profile_at_least` is consumed by the wrappers, not by step files.

- Each file MUST install exactly one tool. Where a tool genuinely depends on 
  another, install the dependency in its own file and add both calls to 
  `run_install_steps` in the right order.

- A step that downloads an archive or a `.deb` SHOULD work in a temporary
  directory and restore the original working directory.

  Create the directory with `mktemp -d`, capture the working directory
  before `cd`-ing in, then `cd` back and `rm -rf` the temporary directory
  on the way out. See `run/inc/dev/lazygit.sh` and `run/inc/dev/delta.sh`
  for the established pattern.

- Steps MUST target Debian-based Linux only. Use `apt-get`, `dpkg`, and `.deb` 
  artifacts. Do not branch on distribution or add fallbacks for other package 
  managers. The supported environment is recorded in the `## ☑️ Requirements` 
  section of `README.md`.

- You MUST use `apt-get` in scripts, never `apt`. In a non-interactive
  context `apt` warns it has no stable CLI interface, and its output format can
  change between Debian and Ubuntu releases, breaking any parsing or log
  diffing that depends on it.

- You MUST pass `-y` to every mutating `apt-get` invocation. `apt-get install`,
  `apt-get remove`, `apt-get purge`, and `apt-get autoremove` all prompt for
  confirmation otherwise, which stalls an unattended bootstrap run. Pass the
  equivalent flag for any other installer too, so the run completes unattended
  in Docker builds and CI.

- You MUST run `apt-get update` before installing from a newly-added
  source. Where a step registers a new APT source — a `.list` file or a 
  `Signed-By` keyring — follow it with an update so the new index is available:

  ```bash
  superdo apt-get update
  superdo apt-get install -y <package>
  ```

  You SHOULD NOT update before installing from a source that was already
  present. The bootstrap entry point handles the initial update, and a
  redundant update costs time on every run.

- You SHOULD query package state with `dpkg` rather than `apt`, and you
  MUST NOT prefix a read-only query with `superdo`. Queries need no
  privileges, and elevating them obscures which calls genuinely mutate the
  machine.

- A step SHOULD end by echoing the installed version, where the tool
  exposes `--version`. It makes provisioning logs useful when diagnosing
  differences between devcontainer builds.

- Steps MUST follow the project's shell conventions: an
  `#!/usr/bin/env bash` shebang, two-space indentation, lowercase
  snake-case local variables, and `source` rather than `.`. These match the
  existing style and the `.shellcheckrc` configuration.

## Edge cases

- The tool depends on a language runtime. Where the tool needs Node, Python, or 
  another runtime installed earlier in the run — a global npm package, say — 
  confirm that the runtime's call in `run_install_steps` precedes the new one. 
  Do not re-install the runtime inside the tool's own step file.

- The tool modifies `.bashrc`. Guard the append with a `grep -q` check, so 
  re-running the bootstrap does not duplicate exports. See `run/inc/exec/node.sh` 
  for the pattern.

- The tool needs a third-party APT repository. Register the repository in its 
  own `pkg/*` step, and keep the install itself a plain APT step. Call the 
  registry with the same wrapper as the packages it serves — `gui_step` when 
  every package is a `gui_step`, `tui_step` when every package is a `tui_step` 
  — so the other profiles do not register a repository they can never install 
  from.

- The tool is being removed. Delete the step file, remove its call from 
  `run_install_steps`, drop its rows from `README.md` and `NOTES.md`, and add 
  an `[Unreleased]` changelog entry. Consider whether the bootstrap SHOULD also 
  remove an already-installed copy from existing machines (`apt-get remove -y …`) 
  — usually yes, so that existing machines converge on the new desired state.

- The step must run only on first provisioning. System compatibility checks 
  (`sys/checks.sh`) and the base `util/*` installs live inline in `run/install`, 
  ahead of `run_install_steps`, rather than as steps in the shared sequence. 
  Add to that inline sequence only for genuine first-run plumbing.

## Examples

- A minimal step backed by an APT package.

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

- A step backed by a third-party APT source. Registering the repository is a
  separate `pkg/*` step (called earlier in the sequence), and `sys/update.sh`
  refreshes every index before any `dev/*` step runs, so the install step
  itself stays a plain APT install with no `apt-get update`.

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

  superdo apt-get install -y gh
  gh --version
  ```

- APT call forms, for the install commands inside a step:

  - Install a package — `superdo apt-get install -y <package>`.
  - Remove a package — `superdo apt-get remove -y <package>`.
  - Remove a package and its configuration — `superdo apt-get purge -y <package>`.
  - Update the package index — `superdo apt-get update`.
  - Install a downloaded `.deb` — `superdo dpkg -i <file>.deb`.
  - Test whether a package is installed  — `dpkg -s <package> >/dev/null 2>&1`.
  - Read the installed version — `dpkg -s <package> | grep -oP 'Version: \K[^ ]+'`.
  - List installed packages — `dpkg -l`.
  - Search available packages — `apt-cache search <term>`.
  - Show package details — `apt-cache show <package>`.
