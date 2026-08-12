# `tmux` session persistence: keep `tmux-resurrect`/`tmux-continuum`

- Authors: Kieran Potts [@kieranpotts]
- Created: 2026-08-06
- Decision date: 2026-08-06
- PR: —

## Status

ACCEPTED

## Context

The `devtools` repo's `tmux.conf` uses two TPM plugins to persist `tmux`
sessions across reboots. Without these TPM plugins, the `tmux` server, and
everything running inside it, does not survive a restart.

- `tmux-resurrect` saves session/window/pane layout and working
  directories to disk, and can restore them on demand.

- `tmux-continuum` automates resurrect. It saves every 15 minutes and
  auto-restores on `tmux` start.

This restores pane _structure_ only. A running command is not resumed,
just the shell and its working directory.

`lazy-tmux` (<https://lazy-tmux.xyz/>) was raised as a candidate replacement
for these TPM plugins. It is a standalone Go CLI (not a TPM plugin) that
snapshots windows, panes, layout, scrollback, and the running command line, and
restores by replaying that metadata through an interactive fuzzy-search picker.
It has its own autosave daemon, comparable to continuum's, and an optional
"restore on tmux startup" hook. It does not use CRIU or any real process-state
check-pointing. A "resumed" command is re-run from scratch, with prior scrollback
pasted back in.

## Decision

Keep `tmux-resurrect` and `tmux-continuum` as the `tmux` session persistence
mechanism. Do not adopt `lazy-tmux` at this time, as it is a relatively new
and immature tool compared to the TPM plugins. `resurrect`/`continuum` are
~10 years old with a large install base. `lazy-tmux` is young (188 stars,
39 open issues, single maintainer) with no long-term stability track record.

## Consequences

- Session restore after a reboot remains structure-only (windows, panes,
  layout, working directories). Scrollback and running processes are not
  restored.

- Revisit if `lazy-tmux` crosses the low-risk maturity bar (eg. stable
  releases, wider adoption, lower open-issue churn), or scrollback loss on
  reboot becomes an actual recurring pain point that outweighs the added
  maintenance surface of a new tool.
