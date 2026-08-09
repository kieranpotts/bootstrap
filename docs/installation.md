# Installation

1. Clone this repository on the target machine.

2. From the root directory of this repository, run `./run/install`.

   By default this installs the `tui` profile: everything that works without
   a display. Pass `--profile=gui` for the full workstation install:

   ```
   ./run/install --profile=gui
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
answering `n` skips it and moves on to the next tool. Two kinds of step are
never prompted: lower-level plumbing (base utilities, APT and
package-repository setup), and the Agent-profile tools listed in
[Tools](./tools.md) — including the Node.js and Python runtimes. The
remaining language runtimes (Docker CE, OpenJDK, PHP, Rust) are prompted like
any other tool.

You are only ever prompted for tools the selected profile actually installs.
Anything outside it is skipped silently.

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

`--profile` selects how much gets installed. It answers the question "who is
driving this machine?", and the three answers are cumulative — each profile
contains the one before it:

| Profile | Flag                    | For                                             |
|---------|-------------------------|-------------------------------------------------|
| `agent` | `--profile=agent`       | Nobody. A headless container running agents.    |
| `tui`   | *(the default)*         | A human at a terminal, with no display.         |
| `gui`   | `--profile=gui`         | A human at a desktop. The full workstation.     |

```
./run/install --profile=agent
./run/install
./run/install --profile=gui
```

See [Tools](./tools.md) for the per-program breakdown of what each profile
installs. `agent` is the profile used to build the
[`docker-devcontainer`](https://hub.docker.com/r/kieranpotts/docker-devcontainer)
image; it installs nothing that assumes a human or a display, and never
prompts, since every step it contains is one the bootstrap treats as
non-negotiable.

> **Note:** the `tui` name describes the *environment*, not the shape of the
> tools. That profile holds plenty of non-interactive CLIs (`aws`, `ffmpeg`,
> `terraform`) alongside the terminal UIs it is named for. What its members
> have in common is that a human wants them and a display is not required.

## Updating an existing machine

`./run/install` is idempotent, so keeping a machine up to date is just
re-running it: it refreshes APT repositories, upgrades installed packages,
and re-runs every per-tool install step. Tools that are already current are
left untouched and outdated ones are upgraded.

```
./run/install
```

Pass `--profile=gui` to also update GUI applications, and `--yes` to skip the
per-tool prompts described above:

```
./run/install --profile=gui --yes
```

You may still need to re-run `./run/install` from time-to-time to get
updates for components that are installed directly from `.DEB` package
downloads, and other mechanisms that bypass the APT package manager.

## Logging output

**Tip:** To stream the output to a log file instead of the terminal, extend the
command as below. `2>&1` merges stderr into stdout.

```
./run/install --profile=gui > install.log 2>&1
```

Alternatively, pipe stderr and stdout to `tee`, which will stream to the log
file _and_ pass it through to the terminal at the same time. If you do this,
preserve `make`'s exit code, else `tee` will mask it with its own:

```
set -o pipefail
./run/install --profile=gui 2>&1 | tee install.log
```
