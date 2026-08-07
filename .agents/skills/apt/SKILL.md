---
name: apt
description: >-
  Apply this project's conventions for invoking APT from bootstrap scripts.
  Use when writing or reviewing a bootstrap script that installs, removes,
  or queries packages on Debian-based systems, or when the user says
  "install <package> via apt", "check this apt command", or asks why a
  package step is prompting or failing on a fresh machine. Do not use it to
  run package operations against the current machine outside a bootstrap
  script.
compatibility: >-
  requires Read, Edit, Glob, Grep, Bash (apt-get, apt-cache, dpkg)
license: CC0-1.0
---

# APT

Apply this project's conventions for calling APT from bootstrap scripts:
`apt-get` rather than `apt`, `-y` on every mutating call, and `superdo`
rather than `sudo`. Do not decide whether a tool belongs in the bootstrap
run, nor where its step file lives — that is settled elsewhere.

## Parameters

Determine the following information from the surrounding context and
environment. You MUST NOT prompt the user for clarification on this task's
requirements. If you cannot determine the requirements, stop and alert the
user with an error message.

- **The APT operation — REQUIRED.** The package or packages to install,
  remove, or query, and whether the task is to write a new call or review
  an existing one.

- **The target script — REQUIRED.** The bootstrap script the call belongs
  in. Take it from the surrounding context; where the context names only a
  tool, search `run/inc/` for a step file carrying that tool's canonical
  short name.

## Success criteria

- Every APT invocation in the target script MUST call `apt-get`, never
  `apt`.

- Every mutating APT invocation MUST pass `-y`, so the run completes with
  no terminal attached.

- Every `apt-get` invocation MUST be prefixed with `superdo`.

- An `apt-get update` MUST precede the first install that draws on a source
  the same change added.

- The shared helpers under `run/inc/fn/` MUST be unchanged. This skill
  governs how a step calls APT, not how the helpers behave.

## Rules

- You MUST use `apt-get` in scripts, never `apt`.

  ```bash
  # ✅ Yes:
  superdo apt-get install -y curl

  # ❌ No:
  superdo apt install curl
  ```

  Called from a non-interactive context, `apt` warns `WARNING: apt does not
  have a stable CLI interface`. Worse, its output format may change between
  Debian and Ubuntu releases, breaking any parsing or log diffing that
  depends on it.

  You MAY use `apt` when typing interactively at a terminal, where its
  progress bar and colorized output help.

- You MUST pass `-y` to every mutating invocation.

  `apt-get install`, `apt-get remove`, `apt-get purge`, and
  `apt-get autoremove` all prompt for confirmation otherwise, which stalls
  an unattended bootstrap run.

  ```bash
  superdo apt-get install -y <package>
  superdo apt-get remove -y <package>
  ```

- You MUST run `apt-get update` before installing from a newly-added
  source.

  Where a step registers a new APT source — a `.list` file or a `Signed-By`
  keyring — follow it with an update so the new index is available:

  ```bash
  superdo apt-get update
  superdo apt-get install -y <package>
  ```

  You SHOULD NOT update before installing from a source that was already
  present. The bootstrap entry point handles the initial update, and a
  redundant update costs time on every run.

- You MUST prefix every `apt-get` call with `superdo`, never `sudo`.

  The `superdo` helper invokes the command directly when running as root,
  as in Docker image builds, and prefixes `sudo` otherwise. Calling `sudo`
  directly breaks the Docker build path, where no `sudo` is present.

  ```bash
  superdo apt-get install -y <package>
  ```

- You SHOULD query package state with `dpkg` rather than `apt`, and you
  MUST NOT prefix a read-only query with `superdo`. Queries need no
  privileges, and elevating them obscures which calls genuinely mutate the
  machine.

## Examples

- Install a package: `superdo apt-get install -y <package>`

- Remove a package: `superdo apt-get remove -y <package>`

- Remove a package and its configuration:
  `superdo apt-get purge -y <package>`

- Update the package index: `superdo apt-get update`

- Install a downloaded `.deb`: `superdo dpkg -i <file>.deb`

- Test whether a package is installed:
  `dpkg -s <package> >/dev/null 2>&1`. This is the established idiom in
  `run/inc/`, and it is authoritative where a tool's own `--version` is
  not.

- Read the installed version:
  `dpkg -s <package> | grep -oP 'Version: \K[^ ]+'`

- List installed packages: `dpkg -l`

- Search available packages: `apt-cache search <term>`

- Show package details: `apt-cache show <package>`

## References

- [`AGENTS.md`](../../AGENTS.md) \
  Read for the project-wide rules these conventions sit under, including
  idempotency and the Debian-only target.

- [`run/inc/fn/superdo.sh`](../../run/inc/fn/superdo.sh) \
  Read when you need the exact behavior of `superdo` under root versus a
  regular user.

- [`docs/requirements.md`](../../docs/requirements.md) \
  Read to confirm which distributions and releases the bootstrap supports
  before assuming a package is available.
