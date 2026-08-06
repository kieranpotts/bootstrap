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

Pass `--gui` to also update GUI applications:

```
./run/update --gui
```

You may still need to run `./run/update` from time-to-time to get updates for
components  that are installed directly from `.DEB` package downloads, and 
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
