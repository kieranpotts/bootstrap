# TODO

## Candidate `cli` profile utilities missing from `debian:bookworm-slim`

Following the `vim-tiny`/`less` commit (`4a66ead`), a check of the actual
`debian:bookworm-slim` image against `run/inc/fn/install-steps.sh` turned up
further gaps. Same test applied: does an unattended agent need this itself,
or does something else shell out to it?

**High value — verified absent from the base image, same class of gap as `less`/`vim`:**

- [x] `procps` — gives `ps`, `top`, `free`, `uptime`, `watch`, `pkill`/`pgrep`.
  There is currently no way to list or signal-by-name a background process
  (eg. a dev server an agent started) — `kill` only works if the PID is
  already known. Likely the single biggest gap for the `cli` profile.
  Actioned: added as `run/inc/util/procps.sh`, wired in as a `cli_step`.
  Uncommitted, pending review.
- `psmisc` — `killall`, `fuser`, `pstree`. Complements `procps` for the same
  "find and kill a process" workflow.
- `lsof` — verified missing; the standard tool for "why is `EADDRINUSE`
  happening."
- `file` — verified missing; scripts and linters commonly shell out to it
  for MIME/type sniffing.

**Medium value — networking diagnostics, still headless-appropriate:**

- `openssh-client` (`ssh`, `scp`, `sftp`) — verified missing. `git`, `gh`,
  and `git-lfs` are already `cli_step`, but there's no SSH client for
  `git@github.com:`-style remotes.
- `iproute2` (`ip`) and/or `bind9-dnsutils` (`dig`/`host`) + `iputils-ping`
  — verified missing; basic "can this container reach the registry/API"
  triage.
- `rsync` — verified missing, commonly assumed present by scripts.

**Lower value — archive-format completeness (matches existing `tar`/`unzip`/`zip`):**

- `xz-utils`, `bzip2` — verified missing; many upstream release tarballs
  ship as `.tar.xz`.

**Considered and rejected:**

- `man-db` — bookworm-slim deliberately strips docs via a dpkg exclude
  policy; reinstalling it fights the base image's own intent, and agents
  use `--help`, not `man`.
- `strace`/`ltrace`/`tree`/`xxd` — real tools, but more "human debugging
  session" than "unattended agent needs this by default." Candidates for
  `tui`, not `cli`, if added at all.

Leaning towards adding `procps`, `psmisc`, `file`, and `lsof` to the `cli`
profile first — closest match to the `less` rationale.
