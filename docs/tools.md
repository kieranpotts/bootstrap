# Tools

What gets installed by each of the three install profiles. The profiles are
cumulative — `cli` ⊆ `tui` ⊆ `gui` — and a ✅ means the program is installed
in that profile:

- **CLI** — `./run/install --profile=cli`. The minimal tool set for a
  coding agent working unattended in a headless container (eg. the
  [`docker-devcontainer`](https://hub.docker.com/r/kieranpotts/docker-devcontainer)
  image). Nothing here needs a human or a display.

- **TUI** — `./run/install --profile=tui`. Everything in CLI, plus the tools
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
| `bzip2`                      | ✅  | ✅  | ✅  |
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
| `dig`                        | ✅  | ✅  | ✅  |
| `dive`                       | —   | ✅  | ✅  |
| `docker`                     | —   | ✅  | ✅  |
| `docker-credential-pass`     | —   | ✅  | ✅  |
| `docker-mcp`                 | —   | ✅  | ✅  |
| `drawio`                     | —   | —   | ✅  |
| `dropbox`                    | —   | —   | ✅  |
| `edge`                       | —   | —   | ✅  |
| `editorconfig-checker`       | ✅  | ✅  | ✅  |
| `ffmpeg`                     | —   | ✅  | ✅  |
| `file`                       | ✅  | ✅  | ✅  |
| `firefox`                    | —   | —   | ✅  |
| `frame0`                     | —   | —   | ✅  |
| `gh`                         | ✅  | ✅  | ✅  |
| `gh-dash`                    | —   | ✅  | ✅  |
| `ghostty`                    | —   | —   | ✅  |
| `git`                        | ✅  | ✅  | ✅  |
| `git-lfs`                    | ✅  | ✅  | ✅  |
| `gnupg`                      | ✅  | ✅  | ✅  |
| `hermes-agent`               | —   | ✅  | ✅  |
| `htop`                       | —   | ✅  | ✅  |
| `icoutils`                   | ✅  | ✅  | ✅  |
| `inotify-tools`              | ✅  | ✅  | ✅  |
| `inshellisense`              | —   | ✅  | ✅  |
| `insomnia`                   | —   | —   | ✅  |
| `ip`                         | ✅  | ✅  | ✅  |
| `jdk`                        | —   | ✅  | ✅  |
| `jetbrains-toolbox`          | —   | —   | ✅  |
| `jq`                         | ✅  | ✅  | ✅  |
| `keepassxc`                  | —   | —   | ✅  |
| `lazydocker`                 | —   | ✅  | ✅  |
| `lazygit`                    | —   | ✅  | ✅  |
| `lazynpm`                    | —   | ✅  | ✅  |
| `less`                       | ✅  | ✅  | ✅  |
| `litellm`                    | —   | ✅  | ✅  |
| `lmstudio`                   | —   | —   | ✅  |
| `lsb-release`                | ✅  | ✅  | ✅  |
| `lsof`                       | ✅  | ✅  | ✅  |
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
| `ping`                       | ✅  | ✅  | ✅  |
| `postman`                    | —   | —   | ✅  |
| `pre-commit`                 | ✅  | ✅  | ✅  |
| `procps`                     | ✅  | ✅  | ✅  |
| `proton-mail`                | —   | —   | ✅  |
| `proton-vpn`                 | —   | —   | ✅  |
| `psmisc`                     | ✅  | ✅  | ✅  |
| `python`                     | ✅  | ✅  | ✅  |
| `qwen-code`                  | —   | ✅  | ✅  |
| `ripgrep`                    | ✅  | ✅  | ✅  |
| `rocm`                       | —   | ✅  | ✅  |
| `rsync`                      | ✅  | ✅  | ✅  |
| `rust`                       | —   | ✅  | ✅  |
| `shellcheck`                 | ✅  | ✅  | ✅  |
| `skills-ref`                 | ✅  | ✅  | ✅  |
| `software-properties-common` | ✅  | ✅  | ✅  |
| `sourcegit`                  | —   | —   | ✅  |
| `ssh`                        | ✅  | ✅  | ✅  |
| `tar`                        | ✅  | ✅  | ✅  |
| `terraform`                  | —   | ✅  | ✅  |
| `tmux`                       | ✅  | ✅  | ✅  |
| `unzip`                      | ✅  | ✅  | ✅  |
| `vim`                        | ✅  | ✅  | ✅  |
| `voxd`                       | —   | —   | ✅  |
| `vscode`                     | —   | —   | ✅  |
| `vscode-insiders`            | —   | —   | ✅  |
| `vscodium`                   | —   | —   | ✅  |
| `warp`                       | —   | —   | ✅  |
| `wget`                       | ✅  | ✅  | ✅  |
| `xpdf-reader`                | —   | ✅  | ✅  |
| `xz`                         | ✅  | ✅  | ✅  |
| `zed`                        | —   | —   | ✅  |
| `zellij`                     | —   | ✅  | ✅  |
