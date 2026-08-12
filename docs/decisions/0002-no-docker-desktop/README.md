# Docker on Linux: native engine only, no Docker Desktop

- Authors: Kieran Potts [@kieranpotts]
- Created: 2026-07-24
- Decision date: 2026-07-24
- PR: —

## Status

ACCEPTED

## Context

Docker Desktop was previously also installed on GUI machines, alongside the
native Docker engine. On Linux, Docker Desktop runs its own daemon inside a VM
and hijacks the active Docker CLI context — flipping it to `desktop-linux` while
running, reverting it back to `default` when stopped. This conflicted with the
native engine and broke tools that rely on the default daemon context, notably
VS Code devcontainers, which failed to start whenever Docker Desktop was not
running.

## Decision

Do not install Docker Desktop. The native Docker Engine (Docker CE) is the only
Docker runtime provisioned on Linux machines.

## Consequences

- One Docker context (`default`) is active at all times. No annoying
  context-flipping between `default` and `desktop-linux`.

- Devcontainer tooling (eg. VS Code) works regardless of whether a GUI Docker
  client is running.

- `lazydocker` and `ctop` are installed instead, as CLI-based replacements for
  day-to-day container inspection.

- Revisit if a future need specifically requires Docker Desktop's VM-backed
  daemon (eg. Windows/WSL2 container support) that the native Linux engine
  cannot provide.

## References

- [CHANGELOG — 1.4.0](../../../CHANGELOG.md)
