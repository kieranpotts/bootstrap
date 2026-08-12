# Debugging

To help debug issues with the install script, it is recommended to stream the
output to a log file instead of the terminal. Use the command below. `2>&1`
merges stderr into stdout.

```sh
make install --profile=gui > install.log 2>&1
```

Alternatively, pipe stderr and stdout to `tee`, which will stream to the log
file _and_ pass it through to the terminal at the same time. If you do this,
preserve `make`'s exit code, else `tee` will mask it with its own:

```sh
set -o pipefail
make install --profile=gui 2>&1 | tee install.log
```
