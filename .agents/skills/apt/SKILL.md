---
name: apt
description: Use this skill when writing or reviewing bootstrap scripts that install, remove, or query packages via APT on Debian-based systems.
compatibility: requires Debian-based Linux (apt-get/dpkg)
license: MIT
---

# APT package manager

There are two front-ends to APT:

- `apt-get`: Designed for scripts and automation, this offers a stable API that is guaranteed not to change.

- `apt`: Designed for interactive terminal use, this is explicitly unstable across versions.

**Always use `apt-get` in scripts.** `apt` will warn you with `WARNING: apt does not have a stable CLI interface` if called from a non-interactive context. Worse, its output format may change between Ubuntu/Debian releases, breaking any parsing or log diffing your scripts depend on.

Use `apt` only when typing interactively at a terminal where its progress bar and colorized output are helpful.

## Rules

-   **Use `apt-get`, never `apt`, in scripts.**

    ```bash
    # ✅ Yes:
    superdo apt-get install -y curl

    # ❌ No:
    superdo apt install curl
    ```

-   **Always pass `-y` to non-interactive commands.**

    `apt-get install`, `apt-get remove`, and `apt-get autoremove` all require `-y` to suppress the confirmation prompt so the bootstrap run completes unattended.

    ```bash
    superdo apt-get install -y <package>
    superdo apt-get remove -y <package>
    ```

-   **Run `apt-get update` before installing from a new source.**

    When a step adds a new APT source (a `.list` file or a Signed-By keyring), immediately follow with `apt-get update` so the new index is available before the install:

    ```bash
    superdo apt-get update
    superdo apt-get install -y <package>
    ```

    You do not need to run `apt-get update` before installing from sources that were already present. The bootstrap entry point handles the initial update.

-   **Use `superdo`, never `sudo` directly.**

    See the [install-step skill](../install-step/SKILL.md) for the rationale. Every `apt-get` call must be prefixed with `superdo`:

    ```bash
    superdo apt-get install -y <package>
    ```

## Common commands

- Install a package: `superdo apt-get install -y <package>`

- Remove a package: `superdo apt-get remove -y <package>`

- Remove a package and its config: `superdo apt-get purge -y <package>`

- Update package index: `superdo apt-get update`

- Check if a package is installed: `dpkg -l <package> 2>/dev/null \| grep -q '^ii'`

- List installed packages: `dpkg -l`

- Search available packages: `apt-cache search <term>`

- Show package details: `apt-cache show <package>`

## References

- [install-step skill](../install-step/SKILL.md): Conventions for writing bootstrap install scripts.

- [`run/inc/fn/superdo.sh`](../../run/inc/fn/superdo.sh): Source of the `superdo` helper.
