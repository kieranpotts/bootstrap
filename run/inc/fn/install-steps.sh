#!/usr/bin/env bash

#
# Shared install step sequence.
#
# Sourced by `run/install`. Defines `run_install_steps`, which does:
#
#   - APT setup and third-party repository registration (`sys/apt.sh`, `pkg/*`)
#   - System update and upgrade (`sys/update.sh`, `sys/upgrade.sh`)
#   - Language runtimes (`exec/*`)
#   - Web browsers (`web/*`)
#   - Applications (`app/*`)
#   - Developer tooling (`dev/*`)
#   - Ops tooling (`ops/*`)
#   - Hardware tooling (`phy/*`)
#   - `.bashrc` configuration and cleanup (`sys/bashrc.sh`, `sys/teardown.sh`)
#
# This file is the single source of truth for *what each profile installs*.
# Every step is classified here, at the call site, rather than by a guard
# inside the step file - so the answer to "what is actually in my image?"
# fits on one screen, instead of being scattered across ninety files:
#
#   cli_step      Runs in every profile. The minimal tooling a coding agent
#                 needs to work unattended in a headless container.
#   tui_step      Runs in `tui` (the default) and `gui`. Needs a human, but
#                 no display.
#   gui_step      Runs in `gui` only. Needs a display.
#   step          Runs in every profile, unconditionally. Reserved for the
#                 sys/* plumbing that has to run before anything else.
#
# See `profile_step` in `run/inc/fn/steps.sh`, and `docs/tools.md` for the
# table this file produces.
#

# run_install_steps - Run the shared install step sequence.
#
# Requires the caller to have already sourced the helper functions in
# `run/inc/fn/*.sh` (notably `step`, the `*_step` profile wrappers, and
# `print_step`) and set `inc_path`. Each step runs via `step()` in an isolated
# subshell, so a single failure is logged and does not abort the run.
#
# shellcheck disable=SC2154 # `inc_path` is set by the caller.
run_install_steps() {

  # APT setup.
  step "${inc_path}/sys/apt.sh"

  # Add package repositories. Those serving nothing but GUI applications are
  # `gui_step`s: registering a repository the run can never install from only
  # slows down `apt update` and leaves a key on the machine for nothing.
  gui_step "${inc_path}/pkg/bruno.sh"
  step "${inc_path}/pkg/docker.sh"
  gui_step "${inc_path}/pkg/ghostty.sh"
  step "${inc_path}/pkg/git-lfs.sh"
  step "${inc_path}/pkg/github.sh"
  step "${inc_path}/pkg/hashicorp.sh"
  gui_step "${inc_path}/pkg/keepassxc.sh"
  gui_step "${inc_path}/pkg/microsoft.sh"
  gui_step "${inc_path}/pkg/mozilla.sh"
  gui_step "${inc_path}/pkg/sourcegit.sh"
  gui_step "${inc_path}/pkg/vscodium.sh"
  gui_step "${inc_path}/pkg/warp.sh"

  # Refresh package lists with the new repositories, then upgrade everything
  # (base system + anything newly available via the added repos).
  step "${inc_path}/sys/update.sh"
  step "${inc_path}/sys/upgrade.sh"

  # Utilities. Unlike the base util/* utilities sourced inline in
  # `run/install` (curl, git, gnupg, etc.), htop is an interactive tool a
  # human needs, not plumbing another step depends on, so it belongs here.
  tui_step "${inc_path}/util/htop.sh"

  # Runtime (execution) environments. Node and Python are in every profile -
  # most agent CLIs are npm-installed, and a lot of tooling is Python. The
  # others need a human to have asked for them: not every machine (or agent
  # container) needs a JVM, PHP, Rust, or a full Docker Engine of its own.
  tui_step "${inc_path}/exec/docker.sh"
  tui_step "${inc_path}/exec/jdk.sh"
  cli_step "${inc_path}/exec/node.sh"
  tui_step "${inc_path}/exec/php.sh"
  cli_step "${inc_path}/exec/python.sh"
  tui_step "${inc_path}/exec/rust.sh"

  # Web browsers.
  gui_step "${inc_path}/web/chrome.sh"
  gui_step "${inc_path}/web/edge.sh"
  gui_step "${inc_path}/web/firefox.sh"

  # Applications.
  gui_step "${inc_path}/app/deja-dup.sh"
  gui_step "${inc_path}/app/drawio.sh"
  gui_step "${inc_path}/app/dropbox.sh"
  gui_step "${inc_path}/app/keepassxc.sh"
  gui_step "${inc_path}/app/mozilla-vpn.sh"
  gui_step "${inc_path}/app/obsidian.sh"
  gui_step "${inc_path}/app/open-webui.sh"
  gui_step "${inc_path}/app/orca.sh"
  tui_step "${inc_path}/app/pass.sh"
  gui_step "${inc_path}/app/pied.sh"
  gui_step "${inc_path}/app/proton-mail.sh"
  gui_step "${inc_path}/app/proton-vpn.sh"
  gui_step "${inc_path}/app/voxd.sh"
  tui_step "${inc_path}/app/xpdf-reader.sh"

  # Dev tools.
  tui_step "${inc_path}/dev/aider.sh"
  gui_step "${inc_path}/dev/bruno.sh"
  tui_step "${inc_path}/dev/claude.sh"
  tui_step "${inc_path}/dev/cline.sh"
  cli_step "${inc_path}/dev/codespell.sh"
  tui_step "${inc_path}/dev/continue.sh"
  tui_step "${inc_path}/dev/copilot.sh"
  tui_step "${inc_path}/dev/ctop.sh"
  tui_step "${inc_path}/dev/cursor-cli.sh"
  gui_step "${inc_path}/dev/cursor-gui.sh"
  cli_step "${inc_path}/dev/delta.sh"
  tui_step "${inc_path}/dev/dive.sh"
  tui_step "${inc_path}/dev/docker-credential-pass.sh"
  tui_step "${inc_path}/dev/docker-mcp.sh"
  cli_step "${inc_path}/dev/editorconfig-checker.sh"
  tui_step "${inc_path}/dev/ffmpeg.sh"
  gui_step "${inc_path}/dev/frame0.sh"
  cli_step "${inc_path}/dev/gh.sh"
  tui_step "${inc_path}/dev/gh-dash.sh"
  gui_step "${inc_path}/dev/ghostty.sh"
  cli_step "${inc_path}/dev/git-lfs.sh"
  tui_step "${inc_path}/dev/hermes-agent.sh"
  tui_step "${inc_path}/dev/inshellisense.sh"
  gui_step "${inc_path}/dev/insomnia.sh"
  gui_step "${inc_path}/dev/jetbrains-toolbox.sh"
  tui_step "${inc_path}/dev/lazydocker.sh"
  tui_step "${inc_path}/dev/lazygit.sh"
  tui_step "${inc_path}/dev/lazynpm.sh"
  gui_step "${inc_path}/dev/lmstudio.sh"
  tui_step "${inc_path}/dev/lynx.sh"
  tui_step "${inc_path}/dev/maven.sh"
  tui_step "${inc_path}/dev/neovim.sh"
  tui_step "${inc_path}/dev/oh-my-posh.sh"
  tui_step "${inc_path}/dev/ollama.sh"
  tui_step "${inc_path}/dev/openclaw.sh"
  tui_step "${inc_path}/dev/opencode.sh"
  tui_step "${inc_path}/dev/pi.sh"
  gui_step "${inc_path}/dev/postman.sh"
  cli_step "${inc_path}/dev/pre-commit.sh"
  tui_step "${inc_path}/dev/qwen-code.sh"
  cli_step "${inc_path}/dev/shellcheck.sh"
  cli_step "${inc_path}/dev/skills-ref.sh"
  gui_step "${inc_path}/dev/sourcegit.sh"
  cli_step "${inc_path}/dev/tmux.sh"
  gui_step "${inc_path}/dev/vscode.sh"
  gui_step "${inc_path}/dev/vscode-insiders.sh"
  gui_step "${inc_path}/dev/vscodium.sh"
  gui_step "${inc_path}/dev/warp.sh"
  gui_step "${inc_path}/dev/zed.sh"

  # Ops tools.
  tui_step "${inc_path}/ops/aws.sh"
  tui_step "${inc_path}/ops/litellm.sh"
  tui_step "${inc_path}/ops/terraform.sh"

  # Hardware utilities.
  tui_step "${inc_path}/phy/amdgpu-top.sh"
  tui_step "${inc_path}/phy/rocm.sh"

  # Tidy up.
  step "${inc_path}/sys/bashrc.sh"
  step "${inc_path}/sys/teardown.sh"

}
