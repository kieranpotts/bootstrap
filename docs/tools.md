# Tools

What gets installed by each of the three install profiles:

- **Agent** — `./run/install --profile=agent`. The minimal tool set for a
  coding agent working unattended in a headless container (eg. the
  [`docker-devcontainer`](https://hub.docker.com/r/kieranpotts/docker-devcontainer)
  image). Runs only `core_step` steps, plus the always-on base utilities
  below the table.

- **CLI** — `./run/install` with no flags. The default workstation install:
  every step except those gated behind `--gui`. A strict superset of Agent.

- **GUI** — `./run/install --gui`. Adds every step gated by
  `is_gui_enabled` on top of CLI. Applications and browsers that need a
  display.

A step lands in Agent only when its call site in
[`run/inc/fn/install-steps.sh`](../run/inc/fn/install-steps.sh) uses
`core_step` instead of `confirm_step` — see that file, and `confirm_step`
in [`run/inc/fn/steps.sh`](../run/inc/fn/steps.sh), for how the profile is
enforced. This table is a manually-maintained summary of that source of
truth; if the two disagree, the code wins.

| Program                      |  Agent  |  CLI  |  GUI  |
|------------------------------|---------|-------|-------|
| `aider`                      |   —    |  ✅   |  —   |
| `amdgpu-top`                 |   —    |  ✅   |  —   |
| `apt-transport-https`        |   ✅    |  ✅   |  —   |
| `aws`                        |   —    |  ✅   |  —   |
| `bruno`                      |   —    |  —   |  ✅   |
| `ca-certificates`            |   ✅    |  ✅   |  —   |
| `chrome`                     |   —    |  —   |  ✅   |
| `claude`                     |   —    |  ✅   |  —   |
| `cline`                      |   —    |  ✅   |  —   |
| `codespell`                  |   ✅    |  ✅   |  —   |
| `continue`                   |   —    |  ✅   |  —   |
| `copilot`                    |   —    |  ✅   |  —   |
| `ctop`                       |   —    |  ✅   |  —   |
| `curl`                       |   ✅    |  ✅   |  —   |
| `cursor-cli`                 |   —    |  ✅   |  —   |
| `cursor-gui`                 |   —    |  —   |  ✅   |
| `deja-dup`                   |   —    |  —   |  ✅   |
| `delta`                      |   ✅    |  ✅   |  —   |
| `dive`                       |   —    |  ✅   |  —   |
| `docker`                     |   —    |  ✅   |  —   |
| `docker-credential-pass`     |   —    |  ✅   |  —   |
| `docker-mcp`                 |   —    |  ✅   |  —   |
| `drawio`                     |   —    |  —   |  ✅   |
| `dropbox`                    |   —    |  —   |  ✅   |
| `edge`                       |   —    |  —   |  ✅   |
| `editorconfig-checker`       |   ✅    |  ✅   |  —   |
| `ffmpeg`                     |   —    |  ✅   |  —   |
| `firefox`                    |   —    |  —   |  ✅   |
| `frame0`                     |   —    |  —   |  ✅   |
| `gh`                         |   ✅    |  ✅   |  —   |
| `gh-dash`                    |   —    |  ✅   |  —   |
| `ghostty`                    |   —    |  —   |  ✅   |
| `git`                        |   ✅    |  ✅   |  —   |
| `git-lfs`                    |   ✅    |  ✅   |  —   |
| `gnupg`                      |   ✅    |  ✅   |  —   |
| `hermes-agent`               |   —    |  ✅   |  —   |
| `htop`                       |   ✅    |  ✅   |  —   |
| `icoutils`                   |   ✅    |  ✅   |  —   |
| `inotify-tools`              |   ✅    |  ✅   |  —   |
| `inshellisense`              |   —    |  ✅   |  —   |
| `insomnia`                   |   —    |  —   |  ✅   |
| `jdk`                        |   —    |  ✅   |  —   |
| `jetbrains-toolbox`          |   —    |  —   |  ✅   |
| `jq`                         |   ✅    |  ✅   |  —   |
| `keepassxc`                  |   —    |  —   |  ✅   |
| `lazydocker`                 |   —    |  ✅   |  —   |
| `lazygit`                    |   —    |  ✅   |  —   |
| `lazynpm`                    |   —    |  ✅   |  —   |
| `litellm`                    |   —    |  ✅   |  —   |
| `lmstudio`                   |   —    |  —   |  ✅   |
| `lsb-release`                |   ✅    |  ✅   |  —   |
| `lynx`                       |   —    |  ✅   |  —   |
| `make`                       |   ✅    |  ✅   |  —   |
| `maven`                      |   —    |  ✅   |  —   |
| `mozilla-vpn`                |   —    |  —   |  ✅   |
| `neovim`                     |   —    |  ✅   |  —   |
| `node`                       |   ✅    |  ✅   |  —   |
| `obsidian`                   |   —    |  —   |  ✅   |
| `oh-my-posh`                 |   —    |  ✅   |  —   |
| `ollama`                     |   —    |  ✅   |  —   |
| `open-webui`                 |   —    |  —   |  ✅   |
| `openclaw`                   |   —    |  ✅   |  —   |
| `opencode`                   |   —    |  ✅   |  —   |
| `orca`                       |   —    |  —   |  ✅   |
| `pass`                       |   —    |  ✅   |  —   |
| `php`                        |   —    |  ✅   |  —   |
| `pi`                         |   —    |  ✅   |  —   |
| `pied`                       |   —    |  —   |  ✅   |
| `postman`                    |   —    |  —   |  ✅   |
| `pre-commit`                 |   ✅    |  ✅   |  —   |
| `proton-mail`                |   —    |  —   |  ✅   |
| `proton-vpn`                 |   —    |  —   |  ✅   |
| `python`                     |   ✅    |  ✅   |  —   |
| `qwen-code`                  |   —    |  ✅   |  —   |
| `ripgrep`                    |   ✅    |  ✅   |  —   |
| `rocm`                       |   —    |  ✅   |  —   |
| `rust`                       |   —    |  ✅   |  —   |
| `shellcheck`                 |   ✅    |  ✅   |  —   |
| `skills-ref`                 |   ✅    |  ✅   |  —   |
| `software-properties-common` |   ✅    |  ✅   |  —   |
| `sourcegit`                  |   —    |  —   |  ✅   |
| `tar`                        |   ✅    |  ✅   |  —   |
| `terraform`                  |   —    |  ✅   |  —   |
| `tmux`                       |   ✅    |  ✅   |  —   |
| `unzip`                      |   ✅    |  ✅   |  —   |
| `voxd`                       |   —    |  —   |  ✅   |
| `vscode`                     |   —    |  —   |  ✅   |
| `vscode-insiders`            |   —    |  —   |  ✅   |
| `vscodium`                   |   —    |  —   |  ✅   |
| `warp`                       |   —    |  —   |  ✅   |
| `wget`                       |   ✅    |  ✅   |  —   |
| `xpdf-reader`                |   —    |  ✅   |  —   |
| `zed`                        |   —    |  —   |  ✅   |

The rows showing ✅ under both Agent and CLI with no corresponding call in
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
own right.
