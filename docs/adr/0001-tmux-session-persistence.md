# `tmux` session persistence: keep `tmux-resurrect`/`tmux-continuum`

## Status

ACCEPTED — 2026-08-06

## Context

The `devtools` repo's `tmux.conf` uses two TPM plugins to persist `tmux`
sessions across reboots (the `tmux` server, and everything inside it, does
not otherwise survive a restart):

- **`tmux-resurrect`** saves session/window/pane layout and working
  directories to disk, and can restore them on demand.

- **`tmux-continuum`** automates resurrect. It saves every 15 minutes and
  auto-restores on `tmux` start.

This restores pane _structure_ only. A running command is not resumed,
just the shell and its working directory.

**`lazy-tmux`** (<https://lazy-tmux.xyz/>) was raised as a candidate
replacement. It is a standalone Go CLI (not a TPM plugin) that snapshots
windows, panes, layout, scrollback, and the running command line, and restores
by replaying that metadata through an interactive fuzzy-search picker. It has
its own autosave daemon, comparable to continuum's, and an optional "restore
on tmux startup" hook. It does not use CRIU or any real process-state
check-pointing. A "resumed" command is re-run from scratch, with prior
scrollback pasted back in.

The two approaches were compared on:

- **Maturity/risk.** `resurrect`/`continuum` are ~10 years old with a large
  install base. `lazy-tmux` is young (188 stars, 39 open issues, single
  maintainer) with no long-term stability track record.

- **Capability gap.** `lazy-tmux` adds scrollback restore and a selective
  restore UI, which `resurrect`/`continuum` lack.

- **Command "resume".** `lazy-tmux`'s replay is a convenience (re-typing the
  command), not true process resumption. A long-running server still
  restarts cold either way.

- **Install/maintenance surface.** `resurrect`/`continuum` are pure TPM
  plugins versioned inline with the rest of `tmux.conf`. `lazy-tmux` is a
  separate Go binary that would need to be installed and kept updated
  outside of TPM.

- **Dependency footprint.** `resurrect`/`continuum` need nothing beyond `tmux`
  and `git` (TPM). `lazy-tmux` needs a Go toolchain to build, or a trusted
  prebuilt release binary.

## Decision

Keep `tmux-resurrect` and `tmux-continuum` as the `tmux` session persistence
mechanism. Do not adopt `lazy-tmux` at this time.

## Consequences

- No change to `devtools`' `tmux.conf` or to bootstrap's provisioning
  steps.

- Session restore after a reboot remains structure-only (windows, panes,
  layout, working directories). Scrollback and running processes are not
  restored.

- Revisit if `lazy-tmux` crosses the low-risk maturity bar (eg. stable
  releases, wider adoption, lower open-issue churn), or scrollback loss on
  reboot becomes an actual recurring pain point that outweighs the added
  maintenance surface of a new tool.
