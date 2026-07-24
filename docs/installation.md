# Installation

1. Clone this repository on the target machine.

2. From the root directory of this repository, run `./run/bootstrap`.

   By default this installs CLI tooling only. Pass `--gui` to additionally
   install GUI applications:

   ```
   ./run/bootstrap --gui
   ```

   Run `./run/bootstrap --help` to print the usage banner.

> **Note:** The bootstrap script is designed to be idempotent, so you can run
> it multiple times without causing any issues. It can be re-run to update the
> system with new changes.

**Tip:** To stream the output to a log file instead of the terminal, extend the
command as below. `2>&1` merges stderr into stdout.

```
./run/bootstrap --gui > bootstrap.log 2>&1
```

Alternatively, pipe stderr and stdout to `tee`, which will stream to the log
file _and_ pass it through to the terminal at the same time. If you do this,
preserve `make`'s exit code, else `tee` will mask it with its own:

```
set -o pipefail
./run/bootstrap --gui 2>&1 | tee bootstrap.log
```
