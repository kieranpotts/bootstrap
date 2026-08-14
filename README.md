# Bootstrap

**Provisioning scripts for my standard local development environment.**

## ☑️ Requirements

- Debian-based Linux distribution (REQUIRED)
- Bash (REQUIRED)
- Git (REQUIRED)
- Make (OPTIONAL)

WSL is no longer supported.

## 📦 Installation

1.  Clone this repository on the target machine.

2.  From the root directory of this repository, run `make install` or
    `./run/install`.

    You'll be prompted to type one of `cli`, `tui`, or `gui`. For non-interactive
    use, pass the value to the `--profile` option.

    ```
    ./run/install --profile=gui
    ```

See below for the list of tools installed in each profile.

> [!TIP]
> `./run/install` is designed to be idempotent. It can be safely re-run at any
> time to update to the latest changes in the bootstrap config.

## 💻 Programs

The following programs are installed. The profile names describe the shape of
the target _environment_ rather than the format of the _programs_ themselves.

* The `cli` profile installs a minimal toolset for simple, programmatic
  execution in headless environments. It is intended for use in devcontainers
  and other isolated environments where agents may be operated. `vim-tiny`
  also ships here, which may come in handy for humans who need to edit things
  like `.gitconfig` files.

* The `tui` profile is intended for use in environments where the primary
  interface is a terminal. It includes TUI programs like `lazygit`, but also
  non-interactive CLIs like `aws`, `ffmpeg`, and `terraform` — heavier tools
  that you might want to keep out of reach of agents.

* The `gui` profile installs everything in the `cli` and `tui` profiles plus
  graphical applications, browsers, and code editors.

The profiles are cumulative — `cli` ⊆ `tui` ⊆ `gui`.

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
| `pi`                         | ✅  | ✅  | ✅  |
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

## 📓 Developer documentation

See the [contributing guidelines](./CONTRIBUTING.md).

-----

Copyright © 2020-present Kieran Potts, [MIT license](./LICENSE.txt)
