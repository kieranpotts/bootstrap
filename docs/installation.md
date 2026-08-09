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

## Install profiles

`--profile` selects how much gets installed. It answers the question "who is
driving this machine?", and the three answers are cumulative — each profile
contains the one before it:

| Profile | Flag                 | For                                             |
|---------|----------------------|-------------------------------------------------|
| `agent` | `--profile=agent`    | Nobody. A headless container running agents.    |
| `tui`   | (`--profile=tui`)    | A human at a terminal, with no display.         |
| `gui`   | `--profile=gui`      | A human at a desktop. The full workstation.     |

```
./run/install --profile=agent
./run/install (--profile=tui)
./run/install --profile=gui
```

See [Tools](./tools.md) for the per-program breakdown of what each profile
installs. `agent` is the profile used to build the
[`docker-devcontainer`](https://hub.docker.com/r/kieranpotts/docker-devcontainer)
image; it installs nothing that assumes a human or a display. Every run is
unattended: no profile prompts before installing a step.

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

Pass `--profile=gui` to also update GUI applications:

```
./run/install --profile=gui
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
