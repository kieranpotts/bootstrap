# Considerations

## Installing Docker

The bootstrap scripts install the native Docker Engine (Docker CE), via
`run/inc/exec/docker.sh`. That step is excluded from the CLI profile — a
container does not need a Docker Engine of its own.

Docker Desktop is _not_ installed. On Linux it runs its own daemon in a VM
and hijacks the active Docker CLI context, which conflicts with the native
engine — see the [1.4.0](../CHANGELOG.md) release notes.

## Using Docker on Windows

If you use Windows Subsystem for Linux (WSL 2) for your local development
environment, the recommended approach is to decline the Docker CE step and
instead install
[Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
in the host environment, configured to use WSL as the "back-end" in
which to build and run the containers it manages.

If WSL is not used as the Docker back-end, `docker` commands will not be
available in the WSL environment, but only in the Windows host environment.

See the following links for more information:

- https://docs.docker.com/desktop/wsl/
- https://docs.docker.com/desktop/wsl/best-practices/
- https://docs.docker.com/desktop/wsl/use-wsl/
