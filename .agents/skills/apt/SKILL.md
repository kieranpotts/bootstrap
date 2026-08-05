---
name: apt
description: Use this skill when writing or reviewing bootstrap scripts that install, remove, or query packages via APT on Debian-based systems.
compatibility: requires Debian-based Linux (apt-get/dpkg)
license: CC0-1.0
---

# APT package manager

Use the APT package manager correctly in bootstrap scripts. Always use
`apt-get` (the stable scripting interface) rather than `apt` (the
interactive front-end), pass `-y` to suppress prompts, and prefix every
call with `superdo`.

## Input

Determine the following information from the surrounding context and
environment. You MUST NOT prompt the user for clarification on this task's
requirements. If you cannot determine the required inputs, stop and alert
the user with an error message.

- The APT operation to perform — REQUIRED. The package(s) to install,
  remove, or query, and the context of the bootstrap script being written
  or reviewed.

## Output

Correctly-formed `apt-get` commands in the bootstrap script, using
`superdo`, passing `-y` for non-interactive operation, and running
`apt-get update` before installing from a new source.

This task runs non-interactively to completion. It does not block for
user input. If in doubt about any of the requirements of this task, stop
and print an error message.

## Rules

- Use `apt-get`, never `apt`, in scripts.

  ```bash
  # ✅ Yes:
  superdo apt-get install -y curl

  # ❌ No:
  superdo apt install curl
  ```

  `apt` will warn you with `WARNING: apt does not have a stable CLI
  interface` if called from a non-interactive context. Worse, its output
  format may change between Ubuntu/Debian releases, breaking any parsing
  or log diffing your scripts depend on.

  Use `apt` only when typing interactively at a terminal where its
  progress bar and colorized output are helpful.

- Always pass `-y` to non-interactive commands.

  `apt-get install`, `apt-get remove`, and `apt-get autoremove` all
  require `-y` to suppress the confirmation prompt so the bootstrap run
  completes unattended.

  ```bash
  superdo apt-get install -y <package>
  superdo apt-get remove -y <package>
  ```

- Run `apt-get update` before installing from a new source.

  When a step adds a new APT source (a `.list` file or a Signed-By
  keyring), immediately follow with `apt-get update` so the new index
  is available before the install:

  ```bash
  superdo apt-get update
  superdo apt-get install -y <package>
  ```

  You do not need to run `apt-get update` before installing from sources
  that were already present. The bootstrap entry point handles the
  initial update.

- Use `superdo`, never `sudo` directly.

  See the [install-step skill](../install-step/SKILL.md) for the
  rationale. Every `apt-get` call must be prefixed with `superdo`:

  ```bash
  superdo apt-get install -y <package>
  ```

## Common commands

- Install a package: `superdo apt-get install -y <package>`

- Remove a package: `superdo apt-get remove -y <package>`

- Remove a package and its config: `superdo apt-get purge -y <package>`

- Update package index: `superdo apt-get update`

- Check if a package is installed:
  `dpkg -l <package> 2>/dev/null \| grep -q '^ii'`

- List installed packages: `dpkg -l`

- Search available packages: `apt-cache search <term>`

- Show package details: `apt-cache show <package>`

## Success criteria

- All APT commands in the script use `apt-get`, not `apt`.

- All non-interactive commands pass `-y`.

- Every `apt-get` call is prefixed with `superdo`.

- `apt-get update` is run before installing from any newly-added source.

## References

- [install-step skill](../install-step/SKILL.md): Conventions for writing
  bootstrap install scripts.

- [`run/inc/fn/superdo.sh`](../../run/inc/fn/superdo.sh): Source of the
  `superdo` helper.
