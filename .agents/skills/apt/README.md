# APT

Conventions for calling the APT package manager from the bootstrap scripts
in this repository.

The skill tells an agent to write `apt-get` rather than `apt`, to pass `-y`
on every mutating call, to prefix each call with the `superdo` helper rather
than `sudo`, and to run `apt-get update` only when the same change has just
registered a new package source. It also carries the repository's idioms for
querying package state with `dpkg`. It is a reference for how a call is
written, not a procedure for adding a tool to the provisioning run.

## Interactivity

Non-interactive. The agent works from the surrounding context and the
repository alone, and never blocks on user input, so the skill is safe in
away-from-keyboard and CI workflows. Where the target script or the package
cannot be determined, the agent stops with an error rather than asking.

## How to invoke

> Install ripgrep via apt.

> Check this apt command.

> Review the apt calls in this install step.

> Why does this package step prompt on a fresh machine?

## Recommended models

A small, fast model is sufficient. The skill is a short set of mechanical
substitutions over a handful of command forms, with no open-ended judgment
to exercise.

## Related skills

- [**install-step**](../install-step/) \
  Covers the wider procedure this skill sits inside — choosing a group,
  creating the step file, wiring it into the run, and updating the docs.
  Reach for that skill when a tool is being added, changed, or removed;
  reach for this one when only the shape of an APT call is in question.

## References

- [`AGENTS.md`](../../AGENTS.md) — project-wide bootstrap rules.
- [`run/inc/fn/superdo.sh`](../../run/inc/fn/superdo.sh) — the `superdo`
  helper.
- [`docs/requirements.md`](../../docs/requirements.md) — supported
  distributions.
