# Tools

What gets installed by each of the three install profiles. The profiles are
cumulative — `cli` ⊆ `tui` ⊆ `gui` — and a ✅ means the program is installed
in that profile:

- **CLI** — `./run/install --profile=cli`. The minimal tool set for a
  coding agent working unattended in a headless container (eg. the
  [`docker-devcontainer`](https://hub.docker.com/r/kieranpotts/docker-devcontainer)
  image). Nothing here needs a human or a display.

- **TUI** — `./run/install`, the default. Everything in CLI, plus the tools
  that need a human at a terminal but no display. Note that the name describes
  the *environment*, not the shape of the tools: this profile holds plenty of
  non-interactive CLIs (`aws`, `ffmpeg`, `terraform`) alongside the terminal
  UIs it is named for.

- **GUI** — `./run/install --profile=gui`. Everything in TUI, plus the
  applications, browsers, and editors that need a display. The full
  workstation install.

Which profile a step belongs to is declared at its call site in
[`run/inc/fn/install-steps.sh`](../run/inc/fn/install-steps.sh) — `cli_step`,
`tui_step`, or `gui_step` — and nowhere else. See `profile_step` in
[`run/inc/fn/steps.sh`](../run/inc/fn/steps.sh) for how that is enforced. This
table is a manually-maintained summary of that source of truth; if the two
disagree, the code wins.

| Program                      | CLI | TUI | GUI |
|------------------------------|-----|-----|-----|
| `aider`                      | —   | ✅  | ✅  |
| `amdgpu-top`                 | —   | ✅  | ✅  |
| `apt-transport-https`        | ✅  | ✅  | ✅  |
| `aws`                        | —   | ✅  | ✅  |
| `bruno`                      | —   | —   | ✅  |
| `ca-certificates`            | ✅  | ✅  | ✅  |
| `chrome`                     | —   | —   | ✅  |
| `claude`                     | —   | ✅  | ✅  |
| `cline`                      | —   | ✅  | ✅  |
| `codespell`                  | ✅  | ✅  | ✅  |
| `continue`                   | —   | ✅  | ✅  |
| `copilot`                    | —   | ✅  | ✅  |
| `ctop`                       | —   | ✅  | ✅  |
| `curl`                       | ✅  | ✅  | ✅  |
| `cursor-cli`                 | —   | ✅  | ✅  |
| `cursor-gui`                 | —   | —   | ✅  |
| `deja-dup`                   | —   | —   | ✅  |
| `delta`                      | ✅  | ✅  | ✅  |
| `dive`                       | —   | ✅  | ✅  |
| `docker`                     | —   | ✅  | ✅  |
| `docker-credential-pass`     | —   | ✅  | ✅  |
| `docker-mcp`                 | —   | ✅  | ✅  |
| `drawio`                     | —   | —   | ✅  |
| `dropbox`                    | —   | —   | ✅  |
| `edge`                       | —   | —   | ✅  |
| `editorconfig-checker`       | ✅  | ✅  | ✅  |
| `ffmpeg`                     | —   | ✅  | ✅  |
| `firefox`                    | —   | —   | ✅  |
| `frame0`                     | —   | —   | ✅  |
| `gh`                         | ✅  | ✅  | ✅  |
| `gh-dash`                    | —   | ✅  | ✅  |
| `ghostty`                    | —   | —   | ✅  |
| `git`                        | ✅  | ✅  | ✅  |
| `git-lfs`                    | ✅  | ✅  | ✅  |
| `gnupg`                      | ✅  | ✅  | ✅  |
| `hermes-agent`               | —   | ✅  | ✅  |
| `htop`                       | ✅  | ✅  | ✅  |
| `icoutils`                   | ✅  | ✅  | ✅  |
| `inotify-tools`              | ✅  | ✅  | ✅  |
| `inshellisense`              | —   | ✅  | ✅  |
| `insomnia`                   | —   | —   | ✅  |
| `jdk`                        | —   | ✅  | ✅  |
| `jetbrains-toolbox`          | —   | —   | ✅  |
| `jq`                         | ✅  | ✅  | ✅  |
| `keepassxc`                  | —   | —   | ✅  |
| `lazydocker`                 | —   | ✅  | ✅  |
| `lazygit`                    | —   | ✅  | ✅  |
| `lazynpm`                    | —   | ✅  | ✅  |
| `litellm`                    | —   | ✅  | ✅  |
| `lmstudio`                   | —   | —   | ✅  |
| `lsb-release`                | ✅  | ✅  | ✅  |
| `lynx`                       | —   | ✅  | ✅  |
| `make`                       | ✅  | ✅  | ✅  |
| `maven`                      | —   | ✅  | ✅  |
| `mozilla-vpn`                | —   | —   | ✅  |
| `neovim`                     | —   | ✅  | ✅  |
| `node`                       | ✅  | ✅  | ✅  |
| `obsidian`                   | —   | —   | ✅  |
| `oh-my-posh`                 | —   | ✅  | ✅  |
| `ollama`                     | —   | ✅  | ✅  |
| `open-webui`                 | —   | —   | ✅  |
| `openclaw`                   | —   | ✅  | ✅  |
| `opencode`                   | —   | ✅  | ✅  |
| `orca`                       | —   | —   | ✅  |
| `pass`                       | —   | ✅  | ✅  |
| `php`                        | —   | ✅  | ✅  |
| `pi`                         | —   | ✅  | ✅  |
| `pied`                       | —   | —   | ✅  |
| `postman`                    | —   | —   | ✅  |
| `pre-commit`                 | ✅  | ✅  | ✅  |
| `proton-mail`                | —   | —   | ✅  |
| `proton-vpn`                 | —   | —   | ✅  |
| `python`                     | ✅  | ✅  | ✅  |
| `qwen-code`                  | —   | ✅  | ✅  |
| `ripgrep`                    | ✅  | ✅  | ✅  |
| `rocm`                       | —   | ✅  | ✅  |
| `rust`                       | —   | ✅  | ✅  |
| `shellcheck`                 | ✅  | ✅  | ✅  |
| `skills-ref`                 | ✅  | ✅  | ✅  |
| `software-properties-common` | ✅  | ✅  | ✅  |
| `sourcegit`                  | —   | —   | ✅  |
| `tar`                        | ✅  | ✅  | ✅  |
| `terraform`                  | —   | ✅  | ✅  |
| `tmux`                       | ✅  | ✅  | ✅  |
| `unzip`                      | ✅  | ✅  | ✅  |
| `voxd`                       | —   | —   | ✅  |
| `vscode`                     | —   | —   | ✅  |
| `vscode-insiders`            | —   | —   | ✅  |
| `vscodium`                   | —   | —   | ✅  |
| `warp`                       | —   | —   | ✅  |
| `wget`                       | ✅  | ✅  | ✅  |
| `xpdf-reader`                | —   | ✅  | ✅  |
| `zed`                        | —   | —   | ✅  |

The rows showing ✅ in every column with no corresponding call in
`run/inc/fn/install-steps.sh` (`apt-transport-https`, `ca-certificates`,
`curl`, `git`, `gnupg`, `htop`, `icoutils`, `inotify-tools`, `jq`,
`lsb-release`, `make`, `ripgrep`, `software-properties-common`, `tar`,
`unzip`, `wget`) are the base `util/*` utilities: installed unconditionally
and unprompted directly by `./run/install` (first-time-only - see
`run/install` itself, not `run_install_steps`), so they are present in
every profile.

`pkg/*` (third-party APT repository registration) and `sys/*` (compatibility
checks, APT setup, system update/upgrade, `.bashrc` config, teardown) are
omitted from this table - they are bootstrap plumbing, not tools in their
own right. The `pkg/*` registries serving GUI-only applications are
themselves `gui_step`s, so they are not registered in the other profiles.
