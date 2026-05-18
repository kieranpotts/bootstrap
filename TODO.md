# TODO

Discrete changes that would bring this repo's structure, conventions, and tooling closer to the company `hacksltd/development-environment-bootstrapper` repo. The set of installed applications is intentionally *not* on this list — the two repos serve different audiences (single-user dev VM vs. company workstations) and the tool inventories are expected to differ.

## Helpers & UX

- [x] Add coloured status helpers to [run/inc/utils.sh](run/inc/utils.sh) (or a new sibling module): `print_info`, `print_success`, `print_warning`, `print_error`. Each uses the bold + colour + bracketed label prefix pattern from the company repo's `run/inc/fn/statuses.sh`.

- [ ] Add ANSI code variables (`BOLD`, `RED`, `GREEN`, `YELLOW`, `BLUE`, `RESET`) — either inline in `utils.sh` or in a dedicated module mirroring the company repo's `run/inc/var/ansi-codes.sh`.

- [ ] Decide whether to switch the `startNewTask` banner to the heavier boxed style used by the company repo's `print_step` (`┌──…┐ / │ … │ / └──…┘`). Currently dashed lines. Cosmetic — skip if the lighter style is preferred.

- [ ] Decide whether to replace the plain-echo banners in [run/inc/msg/start.sh](run/inc/msg/start.sh) and [run/inc/msg/finish.sh](run/inc/msg/finish.sh) with the company repo's `┏━━…┓` heavy-box style. Cosmetic — skip if the current style is preferred.

- [ ] Audit each install step for use of the new `print_*` helpers — particularly to replace bare `echo` lines with `print_info` and to surface success/failure consistently.

## Pre-flight checks

- [ ] Add `run/inc/sys/checks.sh` modelled on the company repo's [equivalent](../../../hacksltd/tools/development-environment-bootstrapper/run/inc/sys/checks.sh), guarding the run against non-Debian-based OSes and (where relevant) non-`x86_64` architectures. Prompt before continuing on Ubuntu versions outside the supported set. Source it as the first sourced step in [run/bootstrap](run/bootstrap), after flag parsing.

- [ ] Include the detected OS name, version, and architecture in the start banner so logs are self-describing.

## Idempotency

- [ ] For tools currently re-cloned/re-installed from scratch on every run (most visibly NVM in [run/inc/run/node.sh](run/inc/run/node.sh)), add a version check that skips the destructive reinstall when the pinned version is already present. The company repo's [run/inc/exec/nodejs.sh](../../../hacksltd/tools/development-environment-bootstrapper/run/inc/exec/nodejs.sh) shows the pattern (adapt it to respect this repo's *pinned*-version philosophy rather than its always-latest one).

- [ ] Print the installed version at the end of every install step where the tool exposes `--version`. The `install-step` skill already mandates this rule; audit each existing script in [run/inc/](run/inc/) for compliance and add the missing `echo`s.

## Project metadata

- [ ] Add `.github/ISSUE_TEMPLATE/` templates. Pick the subset that makes sense for a personal repo — most likely `BUG.md`, `FEATURE.md`, `TASK.md`, and `MAINTENANCE.md` — adapted from the twelve templates in the company repo.

- [ ] Add `.github/PULL_REQUEST_TEMPLATE.md`.
