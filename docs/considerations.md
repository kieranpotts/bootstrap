# Considerations

## Using Docker on Windows

The bootstrap scripts do _not_ install Docker.

If you use Windows Subsystem for Linux (WSL 2) for your local development environment, the recommended approach to using Docker in this environment is to install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/) in the host environment, and to configure it to use WSL as the "back-end" in which to build and run the containers it manages.

If WSL is not used as the Docker back-end, `docker` commands will not be available in the WSL environment, but only in the Windows host environment.

See the following links for more information:

- https://docs.docker.com/desktop/wsl/
- https://docs.docker.com/desktop/wsl/best-practices/
- https://docs.docker.com/desktop/wsl/use-wsl/
