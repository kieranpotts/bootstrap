# Plan: narrow the devcontainer tool set

Status: proposed, not yet implemented.

Narrow the set of tools installed into the
[`docker-devcontainer`](https://hub.docker.com/r/kieranpotts/docker-devcontainer)
image, so it carries only what is useful to *agents* running inside the
container — where the human drives from a code editor GUI on the host.

The capitalized words REQUIRED, MUST, MUST NOT, RECOMMENDED, SHOULD,
SHOULD NOT, OPTIONAL, and MAY are to be interpreted as described in
[IETF RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

## Problem

The `--gui` flag answers *"does this need a display?"*. The devcontainer
question is *"does this need a human?"*. These are different axes, and
"not GUI" is currently being used as a proxy for "belongs in the image" —
a poor proxy.

The image build (`src/Dockerfile` in the `docker-devcontainer` repository)
runs the bootstrap with no flags. Because `docker build` has no TTY,
`confirm_step` auto-accepts every prompt (by design — see
`run/inc/fn/steps.sh`), so the container receives *all* 43 non-GUI-gated
steps.

### Evidence

From the last recorded image build: 340+ packages fetched, ~292s total
build time, of which ~224s was spent exporting layers. Packages pulled
into the image included `systemd`, `shared-mime-info`, and
`timgm6mb-soundfont` — a MIDI soundfont.

The soundfont arrives via the FFmpeg recommends chain
(`ffmpeg` → `libfluidsynth` → `timgm6mb-soundfont`), because
`run/inc/dev/ffmpeg.sh` runs a bare `apt-get install -y ffmpeg` with no
`--no-install-recommends` — unlike the Dockerfile's own base installs,
which do pass that flag.

### What is wrongly included today

- **Physically meaningless in a container.** `run/inc/phy/rocm.sh` and
  `run/inc/phy/amdgpu-top.sh` are GPU tools that talk to `/dev/kfd`.
  `run/inc/exec/docker.sh` installs a full Docker Engine *inside* the
  image, including group and service setup.

- **Requires a human at a terminal.** `lazygit`, `lazydocker`, `lazynpm`,
  `ctop`, `gh-dash`, `htop`, `lynx`, `inshellisense` (interactive
  completion UI), and `oh-my-posh` (prompt cosmetics). None of these have
  a consumer inside the container when the human is in an editor GUI on
  the host.

- **Eleven coding agent CLIs.** `aider`, `claude`, `cline`, `continue`,
  `copilot`, `cursor-cli`, `hermes-agent`, `openclaw`, `opencode`, `pi`,
  `qwen-code`. Each is a live external dependency that can break a
  pinned image build.

- **Model servers.** `ollama`, `open-webui`, `litellm`. The container
  should point at the host's Ollama over the network rather than run its
  own. `open-webui` is a web UI and is arguably mis-gated today,
  independent of this work.

## Proposed design

Add a third tier, and express tier membership **at the call site** in
`run/inc/fn/install-steps.sh` — not as a guard inside each step file.

Introduce a `core_step` alongside the existing `step` and `confirm_step`,
with a `--profile=agent` flag selecting only the core steps.

### Why the call site, and not a per-file guard

The `is_gui_enabled || return 0` convention works well for a flag that
~40 files care about. It is the wrong shape here:

- It would require adding a guard line to ~35 step files.

- The guard would read as "am I *excluded*" — the inverse of how
  `is_gui_enabled` reads, which is a subtle and easily-miscopied
  inversion.

- The answer to "what is actually in my image?" would be scattered across
  35 files. At the call site it fits on one screen, which is the question
  that gets asked every time the image feels bloated.

There is precedent: the `step` vs `confirm_step` distinction already
encodes policy at the call site.

### Why the profile lives here, not in the devcontainer repo

The profile definition MUST stay in this repository. If `src/Dockerfile`
maintained its own tool list, it would drift — and this project already
tracks one manual drift problem in `docs/drift.md`. Do not create a
second.

### Caveat on the tier model

A linear tier model cannot cleanly express "container-hostile". ROCm is
not tier-2 *human comfort*; it is physically wrong in a container. Both
land in tier 2 regardless, which works but slightly abuses the meaning.

This is an accepted simplification. The alternative — a tag system —
forces an N-dimensional judgement call on every newly added step, for
little practical gain.

## Proposed core set

The container tier SHOULD contain:

- The `run/inc/util/*` base.

- `exec/node.sh` and `exec/python.sh`. Most agent CLIs are npm-installed,
  and a great deal of tooling is Python.

- `dev/gh.sh`, `dev/git-lfs.sh`, `dev/delta.sh` (plus `util/git.sh`).

- `util/ripgrep.sh` and `util/jq.sh`.

- The self-verification tooling agents lean on: `dev/shellcheck.sh`,
  `dev/codespell.sh`, `dev/editorconfig-checker.sh`, `dev/pre-commit.sh`.

- `dev/skills-ref.sh`.

- The chosen agent CLI(s) — see open question below.

Everything else moves to tier 2 (workstation).

### Judgement calls, not clear-cut

- **`dev/tmux.sh`** — RECOMMENDED for core. Useful for agent-managed
  long-running processes, and there is a supporting ADR at
  `docs/adr/0001-tmux-session-persistence.md`.

- **`dev/docker-mcp.sh`** — depends on whether the container is given a
  host Docker socket.

- **`exec/jdk.sh`, `dev/maven.sh`, `exec/php.sh`, `exec/rust.sh`** —
  core only if that work happens in-container.

## Open question

**Which agent CLI(s) belong in core?** This is the crux, and it drives
most of the size win. Unresolved — must be settled before implementation.

## Incidental fixes

These are independent of the tiering work and can land separately:

- `src/Dockerfile` (in the `docker-devcontainer` repository) calls
  `./run/bootstrap`, the DEPRECATED wrapper. It works, but prints a
  warning to stderr. It MUST be updated to call `./run/install`.

- `run/inc/dev/ffmpeg.sh` SHOULD pass `--no-install-recommends`. That
  alone removes the MIDI soundfont from the image.

- `run/inc/dev/open-webui.sh` is a web UI but is not GUI-gated. Review
  its categorization.

## Implementation outline

1. Settle the open question on agent CLIs.

2. Add `--profile=agent` parsing to `run/install` (and decide whether
   `run/update` needs it), with an `is_agent_profile` predicate in
   `run/inc/fn/gui.sh`, following the existing flag conventions.

3. Add `core_step` to `run/inc/fn/steps.sh`.

4. Reclassify the call sites in `run/inc/fn/install-steps.sh`, keeping
   each group alphabetically sorted.

5. Update `src/Dockerfile` in the `docker-devcontainer` repository to
   call `./run/install --profile=agent`.

6. Rebuild the image and compare package count and layer-export time
   against the figures in the Evidence section above.

7. Update `AGENTS.md` (Feature toggles + Rules), `CHANGELOG.md`, and
   `docs/` as needed.
