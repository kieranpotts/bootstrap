#!/usr/bin/env bash

#
# Shared install step sequence.
#
# Sourced by both `run/install` (full provisioning from scratch) and
# `run/update` (update an already-provisioned machine). Defines
# `run_install_steps`, which does:
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
#   agent_step    Runs in every profile. The minimal tooling a coding agent
#                 needs to work unattended in a headless container.
#   tui_step      Runs in `tui` (the default) and `gui`. Needs a human, but
#                 no display.
#   gui_step      Runs in `gui` only. Needs a display.
#   step          Runs in every profile, unconditionally. Reserved for the
#                 sys/* plumbing that has to run before anything else.
#
# A second, independent rule governs prompting: a call that passes a display
# name is a discrete tool, and the user is asked before it runs; a call
# without one is plumbing, and runs unannounced. That is why the `pkg/*`
# registries are silent while the tools they serve are not. See
# `profile_step` in `run/inc/fn/steps.sh`, and `docs/tools.md` for the table
# this file produces.
#

# run_install_steps - Run the shared install/update step sequence.
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

  # Runtime (execution) environments. Node and Python are in every profile -
  # most agent CLIs are npm-installed, and a lot of tooling is Python. The
  # others need a human to have asked for them: not every machine (or agent
  # container) needs a JVM, PHP, Rust, or a full Docker Engine of its own.
  tui_step "${inc_path}/exec/docker.sh" "Docker CE"
  tui_step "${inc_path}/exec/jdk.sh" "OpenJDK (via Jabba)"
  agent_step "${inc_path}/exec/node.sh"
  tui_step "${inc_path}/exec/php.sh" "PHP (via phpenv)"
  agent_step "${inc_path}/exec/python.sh"
  tui_step "${inc_path}/exec/rust.sh" "Rust (via Rustup)"

  # Web browsers.
  gui_step "${inc_path}/web/chrome.sh" "Google Chrome"
  gui_step "${inc_path}/web/edge.sh" "Microsoft Edge"
  gui_step "${inc_path}/web/firefox.sh" "Firefox"

  # Applications.
  gui_step "${inc_path}/app/deja-dup.sh" "Déjà Dup Backups"
  gui_step "${inc_path}/app/drawio.sh" "Draw.io"
  gui_step "${inc_path}/app/dropbox.sh" "Dropbox"
  gui_step "${inc_path}/app/keepassxc.sh" "KeePassXC"
  gui_step "${inc_path}/app/mozilla-vpn.sh" "Mozilla VPN"
  gui_step "${inc_path}/app/obsidian.sh" "Obsidian"
  gui_step "${inc_path}/app/open-webui.sh" "Open WebUI"
  gui_step "${inc_path}/app/orca.sh" "Orca"
  tui_step "${inc_path}/app/pass.sh" "pass"
  gui_step "${inc_path}/app/pied.sh" "Pied"
  gui_step "${inc_path}/app/proton-mail.sh" "Proton Mail"
  gui_step "${inc_path}/app/proton-vpn.sh" "Proton VPN"
  gui_step "${inc_path}/app/voxd.sh" "VOXD"
  tui_step "${inc_path}/app/xpdf-reader.sh" "XPDF Reader"

  # Dev tools.
  tui_step "${inc_path}/dev/aider.sh" "Aider"
  gui_step "${inc_path}/dev/bruno.sh" "Bruno"
  tui_step "${inc_path}/dev/claude.sh" "Claude Code"
  tui_step "${inc_path}/dev/cline.sh" "Cline Kanban"
  agent_step "${inc_path}/dev/codespell.sh"
  tui_step "${inc_path}/dev/continue.sh" "Continue CLI"
  tui_step "${inc_path}/dev/copilot.sh" "Copilot CLI"
  tui_step "${inc_path}/dev/ctop.sh" "ctop"
  tui_step "${inc_path}/dev/cursor-cli.sh" "Cursor CLI"
  gui_step "${inc_path}/dev/cursor-gui.sh" "Cursor GUI"
  agent_step "${inc_path}/dev/delta.sh"
  tui_step "${inc_path}/dev/dive.sh" "Dive"
  tui_step "${inc_path}/dev/docker-credential-pass.sh" "docker-credential-pass"
  tui_step "${inc_path}/dev/docker-mcp.sh" "Docker MCP Gateway"
  agent_step "${inc_path}/dev/editorconfig-checker.sh"
  tui_step "${inc_path}/dev/ffmpeg.sh" "FFmpeg"
  gui_step "${inc_path}/dev/frame0.sh" "Frame0"
  agent_step "${inc_path}/dev/gh.sh"
  tui_step "${inc_path}/dev/gh-dash.sh" "gh-dash"
  gui_step "${inc_path}/dev/ghostty.sh" "Ghostty"
  agent_step "${inc_path}/dev/git-lfs.sh"
  tui_step "${inc_path}/dev/hermes-agent.sh" "Hermes Agent"
  tui_step "${inc_path}/dev/inshellisense.sh" "inshellisense"
  gui_step "${inc_path}/dev/insomnia.sh" "Insomnia"
  gui_step "${inc_path}/dev/jetbrains-toolbox.sh" "JetBrains Toolbox"
  tui_step "${inc_path}/dev/lazydocker.sh" "LazyDocker"
  tui_step "${inc_path}/dev/lazygit.sh" "LazyGit"
  tui_step "${inc_path}/dev/lazynpm.sh" "LazyNpm"
  gui_step "${inc_path}/dev/lmstudio.sh" "LM Studio"
  tui_step "${inc_path}/dev/lynx.sh" "Lynx"
  tui_step "${inc_path}/dev/maven.sh" "Maven"
  tui_step "${inc_path}/dev/neovim.sh" "Neovim"
  tui_step "${inc_path}/dev/oh-my-posh.sh" "Oh-My-Posh"
  tui_step "${inc_path}/dev/ollama.sh" "Ollama"
  tui_step "${inc_path}/dev/openclaw.sh" "OpenClaw"
  tui_step "${inc_path}/dev/opencode.sh" "OpenCode"
  tui_step "${inc_path}/dev/pi.sh" "Pi Coding Agent"
  gui_step "${inc_path}/dev/postman.sh" "Postman"
  agent_step "${inc_path}/dev/pre-commit.sh"
  tui_step "${inc_path}/dev/qwen-code.sh" "Qwen Code"
  agent_step "${inc_path}/dev/shellcheck.sh"
  agent_step "${inc_path}/dev/skills-ref.sh"
  gui_step "${inc_path}/dev/sourcegit.sh" "SourceGit"
  agent_step "${inc_path}/dev/tmux.sh"
  gui_step "${inc_path}/dev/vscode.sh" "Visual Studio Code"
  gui_step "${inc_path}/dev/vscode-insiders.sh" "Visual Studio Code Insiders"
  gui_step "${inc_path}/dev/vscodium.sh" "VS Codium"
  gui_step "${inc_path}/dev/warp.sh" "Warp"
  gui_step "${inc_path}/dev/zed.sh" "Zed"

  # Ops tools.
  tui_step "${inc_path}/ops/aws.sh" "AWS CLI"
  tui_step "${inc_path}/ops/litellm.sh" "LiteLLM"
  tui_step "${inc_path}/ops/terraform.sh" "Terraform"

  # Hardware utilities.
  tui_step "${inc_path}/phy/amdgpu-top.sh" "amdgpu_top"
  tui_step "${inc_path}/phy/rocm.sh" "ROCm utilities"

  # Tidy up.
  step "${inc_path}/sys/bashrc.sh"
  step "${inc_path}/sys/teardown.sh"

}
