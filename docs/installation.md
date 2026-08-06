# Installation

1. Clone this repository on the target machine.

2. From the root directory of this repository, run `./run/install`.

   By default this installs CLI tooling only. Pass `--gui` to additionally
   install GUI applications:

   ```
   ./run/install --gui
   ```

   Run `./run/install --help` to print the usage banner.

> **Note:** `./run/install` is designed to be idempotent, so you can run it
> multiple times without causing any issues. It can be re-run to pick up new
> changes.

> **Note:** `./run/install` was previously named `./run/bootstrap`. The old
> name still works as a deprecated wrapper, but prefer `./run/install`.

## Per-tool prompts

For every application and runtime/developer/ops/hardware tool it installs or
updates (the `web/*`, `app/*`, `exec/*`, `dev/*`, `ops/*`, and `phy/*`
categories), the bootstrap asks for confirmation before running that step:

```
Install/update LazyGit? (Y/n):
```

Pressing Enter, or answering anything other than `n`/`N`, runs the step;
answering `n` skips it and moves on to the next tool. Lower-level bootstrap
plumbing (base utilities, APT/package-repository setup) is not prompted and
always runs, and neither are the "core" steps listed under Agent in
[Tools](./tools.md) — including the Node.js and Python runtimes. The
remaining language runtimes (Docker CE, OpenJDK, PHP, Rust) are prompted
like any other tool.

Pass `--yes`/`-y` to skip all of these prompts and assume yes, eg. for a
fully unattended run:

```
./run/install --yes
```

> **Note:** Prompts are also skipped automatically — and every step
> proceeds as if answered yes — whenever there's no terminal attached to
> stdin (eg. inside a `docker build` layer, or a CI job). Piping *output*
> to a log file (see [Logging output](#logging-output) below) does not by
> itself suppress prompts, since stdin is untouched; pass `--yes` too if you
> want a logged run to also be unattended.

## Install profiles

By default, `./run/install` provisions a full workstation: every step,
subject to the per-tool prompts above and to `--gui`. Pass
`--profile=agent` to install only the minimal "core" tool set instead —
what a coding agent needs to work unattended in a headless container:

```
./run/install --profile=agent
```

Under this profile every prompted step is skipped outright — no prompt, no
fallback to yes — so what remains is the core steps plus the always-on base
utilities and APT/package-repository setup. See [Tools](./tools.md) for the
per-program breakdown of what each profile installs.

This is the profile used to build the
[`docker-devcontainer`](https://hub.docker.com/r/kieranpotts/docker-devcontainer)
image. Passing `--gui` alongside it installs no GUI applications — every
GUI-gated step is also a prompted step — though it does still register the
GUI-only APT repositories. `./run/update` accepts the same flag, to update
an agent container in place.

## Updating an existing machine

Once a machine has been bootstrapped, keep it up to date with `./run/update`.
This is the lighter-weight companion to `./run/install`. It skips the
first-time-only phases (system compatibility checks and base utility installs)
and instead refreshes APT repositories, upgrades installed packages, and
re-runs every per-tool install step. Each step is idempotent, so tools that
are already current are left untouched and outdated ones are upgraded.
`./run/update` never installs a tool that isn't already present — it only
refreshes what's already there.

```
./run/update
```

Pass `--gui` to also update GUI applications, and `--yes` to skip the
per-tool prompts described above:

```
./run/update --gui --yes
```

You may still need to run `./run/update` from time-to-time to get updates for
components that are installed directly from `.DEB` package downloads, and
other mechanisms that bypass the APT package manager.

Run `./run/update --help` to print the usage banner.

> **Note:** `./run/update` assumes the machine has already been provisioned
> with `./run/install`. On a fresh machine, run `./run/install` first.

## Logging output

**Tip:** To stream the output to a log file instead of the terminal, extend the
command as below. `2>&1` merges stderr into stdout.

```
./run/install --gui > install.log 2>&1
```

Alternatively, pipe stderr and stdout to `tee`, which will stream to the log
file _and_ pass it through to the terminal at the same time. If you do this,
preserve `make`'s exit code, else `tee` will mask it with its own:

```
set -o pipefail
./run/install --gui 2>&1 | tee install.log
```
