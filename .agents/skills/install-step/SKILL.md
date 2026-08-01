---
name: install-step
description: Use this skill when adding a new tool to the bootstrap provisioning run, changing how an existing tool is installed, or removing one. Do NOT use this skill for one-off shell scripts that are not part of the bootstrap run, or for changes to `run/inc/utils.sh` (the shared helpers).
compatibility: requires bash, Debian-based Linux (apt/dpkg)
license: MIT
metadata:
  preferred_model: ollama/CODE_STANDARD
---

# Install step

The conventions defined in this skill keep `./run/bootstrap` idempotent,
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
into `run/bootstrap` in the correct group, with a changelog entry under
`[Unreleased]` in `CHANGELOG.md`. The script passes ShellCheck and
smoke-tests cleanly on a clean target.

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
    - `run/`: Language runtimes and version managers.
    - `dev/`: Developer tooling (CLIs, TUIs, editors, linters).
    - `ops/`: Cloud and infrastructure CLIs.
    - `phy/`: Hardware-related tooling.
    - `msg/`: Start/finish banners only.

    Use the program's canonical short name as the filename (eg. `gh.sh`,
    not `github-cli.sh`).

2.  Create the install script from this template.

    ```bash
    #!/bin/bash

    #
    # Install <Program Name>.
    #
    # <Upstream homepage>
    # <Upstream install docs>
    #

    print_step "Install <Program Name>"

    # Install commands here, using `superdo` instead of `sudo`.
    superdo apt-get install -y <package>
    ```

    The leading comment block is required. It documents what the script
    installs and points readers at the upstream install instructions.

3.  Wire the script into the entry point.

    Add a `source "${repo_root}/<group>/<name>.sh"` line to
    `run/bootstrap` in the correct group, keeping the lines within that
    group sorted alphabetically.

4.  Pin versions when reasonable.

    Where the upstream project ships tagged releases or `.deb`
    artifacts, pin the version in a local variable at the top of the
    script so the install is reproducible. Add a short comment beside
    any pinned version that records where the version number came from
    (eg. an upstream changelog link).

5.  Update the changelog.

    Add a one-line bullet under the `## [Unreleased]` heading in
    `CHANGELOG.md` describing the change (eg. `- Install GitHub CLI
    (\`gh\`).`).

6.  Lint the script.

    Run `shellcheck` against the new or modified file (and
    `run/bootstrap` if it was touched). Resolve any findings before
    committing.

7.  Smoke-test the install.

    On a clean target – or by re-running `./run/bootstrap` on an
    existing host – confirm the new step prints its `STEP N` banner,
    completes without prompts, and that the installed binary is on
    `PATH` and reports a sensible version.

## Rules

- Scripts must be idempotent.

  `./run/bootstrap` is re-run to apply updates as well as on first
  provisioning. Each step must converge on the same end state whether it
  runs against a fresh machine or one that has been bootstrapped many
  times before.

  Prefer package-manager installs and guarded mutations
  (`grep -q … || echo … >> …`) over blind appends.

- Use `superdo`, never `sudo` directly.

  The `superdo` helper in `run/inc/utils.sh` invokes the command
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
  `print_step "Install …"` (or an equivalent verb). The helper prints
  a numbered banner so the bootstrap run is self-narrating, and is the
  contract that downstream scripts depend on for step numbering.

- Guard optional steps with feature toggles.

  CLI flags parsed by `run/bootstrap` are exposed as helper predicates
  in `run/inc/utils.sh`. An install step that should only run under a
  given flag must short-circuit before its `print_step` call so the
  step number is not consumed:

  ```bash
  # GUI-only install. No-op unless `--gui` was passed.
  is_gui_enabled || return 0

  print_step "Install <gui-thing>"
  # ...
  ```

  Available helpers:

  - `is_gui_enabled` – true when `--gui` was passed
    (`install_gui=1`).

- One tool per file.

  Do not bundle unrelated installs into a single script. If a tool
  genuinely depends on another, install the dependency in its own file
  and source both from `run/bootstrap` in the right order.

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

  `#!/bin/bash` shebang, two-space indent, lowercase snake-case for
  local variables, and `source` (already used throughout
  `run/bootstrap`). These match the existing style and `.shellcheckrc`
  configuration.

## Examples

A minimal install step backed by an apt package — see
[`run/inc/util/curl.sh`](../../run/inc/util/curl.sh):

```bash
#!/bin/bash

#
# Install Curl
#

print_step "Installing curl"

superdo apt-get install -y curl
```

An install step that adds a third-party apt source and pins the version
— see [`run/inc/dev/gh.sh`](../../run/inc/dev/gh.sh):

```bash
#!/bin/bash

#
# Install the GitHub CLI (`gh`).
#
# https://github.com/cli/cli
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
#

print_step "Install GitHub CLI"

superdo mkdir -p -m 755 /etc/apt/keyrings
wget -nv -O- https://cli.github.com/packages/githubcli-archive-keyring.gpg | superdo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
superdo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

superdo mkdir -p -m 755 /etc/apt/sources.list.d
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | superdo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

superdo apt-get update
superdo apt-get install gh -y
```

An install step that downloads a release tarball and pins the upstream
version — see [`run/inc/dev/lazygit.sh`](../../run/inc/dev/lazygit.sh)
for the temp-dir pattern.

## Edge cases

- Tools requiring a runtime: If the tool depends on Node, Python, or
  another runtime installed earlier in the run (eg. global npm packages
  like Claude Code or Copilot CLI), confirm that the runtime's `source`
  line in `run/bootstrap` appears before the new step. Do not re-install
  the runtime inside the tool's script.

- Tools that modify `.bashrc`: Guard appends with a `grep -q` check so
  re-running the bootstrap does not duplicate exports. See
  `run/inc/run/node.sh` for the established pattern.

- Removing a tool: Delete the install script, remove its `source` line
  from `run/bootstrap`, and add an "[Unreleased]" changelog entry.
  Consider whether the bootstrap should also remove an already-installed
  copy on existing machines (`apt-get remove …`) — usually yes, so the
  cleanup converges on the new desired state.

## Success criteria

- The install script is idempotent — re-running `./run/bootstrap`
  converges, not duplicates.

- The script uses `superdo` instead of `sudo` directly.

- The first non-comment line is a `print_step` call.

- The script is wired into `run/bootstrap` in the correct group,
  alphabetically sorted.

- The script passes `shellcheck` with no findings.

- A changelog entry has been added under `[Unreleased]`.

## References

- [`./AGENTS.md`](../../AGENTS.md): Project-level rules this skill
  builds on.

- [`run/inc/utils.sh`](../../run/inc/utils.sh): Source of `print_step`
  and `superdo`.

- [`docs/installation.md`](../../docs/installation.md): How the entry
  script is invoked.

- [`docs/considerations.md`](../../docs/considerations.md): Why Docker
  is intentionally excluded.
