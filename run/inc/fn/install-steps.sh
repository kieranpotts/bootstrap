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
# The web/app/dev/ops/phy categories are "one tool per script", so each of
# those runs via `confirm_step` rather than `step` directly — the user gets
# a per-tool Y/n prompt (see `run/inc/fn/steps.sh`) and can skip individual
# applications/tools without editing this file. Every other category
# (apt/pkg/sys/exec setup) always runs unprompted, since those steps are
# bootstrap plumbing rather than a discrete tool the user might opt out of.
#

# run_install_steps - Run the shared install/update step sequence.
#
# Requires the caller to have already sourced the helper functions in
# `run/inc/fn/*.sh` (notably `step`, `confirm_step`, and `print_step`) and
# set `inc_path`. Each step runs via `step()` in an isolated subshell, so a
# single failure is logged and does not abort the run.
#
# shellcheck disable=SC2154 # `inc_path` is set by the caller.
run_install_steps() {

  # APT setup.
  step "${inc_path}/sys/apt.sh"

  # Add package repositories.
  step "${inc_path}/pkg/bruno.sh"
  step "${inc_path}/pkg/docker.sh"
  step "${inc_path}/pkg/ghostty.sh"
  step "${inc_path}/pkg/git-lfs.sh"
  step "${inc_path}/pkg/github.sh"
  step "${inc_path}/pkg/hashicorp.sh"
  step "${inc_path}/pkg/keepassxc.sh"
  step "${inc_path}/pkg/microsoft.sh"
  step "${inc_path}/pkg/mozilla.sh"
  step "${inc_path}/pkg/sourcegit.sh"
  step "${inc_path}/pkg/vscodium.sh"
  step "${inc_path}/pkg/warp.sh"

  # Refresh package lists with the new repositories, then upgrade everything
  # (base system + anything newly available via the added repos).
  step "${inc_path}/sys/update.sh"
  step "${inc_path}/sys/upgrade.sh"

  # Runtime (execution) environments.
  step "${inc_path}/exec/docker.sh"
  step "${inc_path}/exec/jdk.sh"
  step "${inc_path}/exec/node.sh"
  step "${inc_path}/exec/php.sh"
  step "${inc_path}/exec/python.sh"
  step "${inc_path}/exec/rust.sh"

  # Web browsers.
  confirm_step "${inc_path}/web/chrome.sh" "Google Chrome"
  confirm_step "${inc_path}/web/edge.sh" "Microsoft Edge"
  confirm_step "${inc_path}/web/firefox.sh" "Firefox"

  # Applications.
  confirm_step "${inc_path}/app/deja-dup.sh" "Déjà Dup Backups"
  confirm_step "${inc_path}/app/drawio.sh" "Draw.io"
  confirm_step "${inc_path}/app/dropbox.sh" "Dropbox"
  confirm_step "${inc_path}/app/keepassxc.sh" "KeePassXC"
  confirm_step "${inc_path}/app/mozilla-vpn.sh" "Mozilla VPN"
  confirm_step "${inc_path}/app/obsidian.sh" "Obsidian"
  confirm_step "${inc_path}/app/orca.sh" "Orca"
  confirm_step "${inc_path}/app/pass.sh" "pass"
  confirm_step "${inc_path}/app/pied.sh" "Pied"
  confirm_step "${inc_path}/app/proton-mail.sh" "Proton Mail"
  confirm_step "${inc_path}/app/proton-vpn.sh" "Proton VPN"
  confirm_step "${inc_path}/app/voxd.sh" "VOXD"
  confirm_step "${inc_path}/app/xpdf-reader.sh" "XPDF Reader"

  # Dev tools.
  confirm_step "${inc_path}/dev/aider.sh" "Aider"
  confirm_step "${inc_path}/dev/bruno.sh" "Bruno"
  confirm_step "${inc_path}/dev/claude.sh" "Claude Code"
  confirm_step "${inc_path}/dev/cline.sh" "Cline Kanban"
  confirm_step "${inc_path}/dev/codespell.sh" "codespell"
  confirm_step "${inc_path}/dev/continue.sh" "Continue CLI"
  confirm_step "${inc_path}/dev/copilot.sh" "Copilot CLI"
  confirm_step "${inc_path}/dev/ctop.sh" "ctop"
  confirm_step "${inc_path}/dev/cursor-cli.sh" "Cursor CLI"
  confirm_step "${inc_path}/dev/cursor-gui.sh" "Cursor GUI"
  confirm_step "${inc_path}/dev/delta.sh" "Delta (git-delta)"
  confirm_step "${inc_path}/dev/dive.sh" "Dive"
  confirm_step "${inc_path}/dev/docker-credential-pass.sh" "docker-credential-pass"
  confirm_step "${inc_path}/dev/docker-mcp.sh" "Docker MCP Gateway"
  confirm_step "${inc_path}/dev/editorconfig-checker.sh" "editorconfig-checker"
  confirm_step "${inc_path}/dev/ffmpeg.sh" "FFmpeg"
  confirm_step "${inc_path}/dev/frame0.sh" "Frame0"
  confirm_step "${inc_path}/dev/gh.sh" "GitHub CLI"
  confirm_step "${inc_path}/dev/gh-dash.sh" "gh-dash"
  confirm_step "${inc_path}/dev/ghostty.sh" "Ghostty"
  confirm_step "${inc_path}/dev/git-lfs.sh" "Git LFS"
  confirm_step "${inc_path}/dev/hermes-agent.sh" "Hermes Agent"
  confirm_step "${inc_path}/dev/inshellisense.sh" "inshellisense"
  confirm_step "${inc_path}/dev/insomnia.sh" "Insomnia"
  confirm_step "${inc_path}/dev/jetbrains-toolbox.sh" "JetBrains Toolbox"
  confirm_step "${inc_path}/dev/lazydocker.sh" "LazyDocker"
  confirm_step "${inc_path}/dev/lazygit.sh" "LazyGit"
  confirm_step "${inc_path}/dev/lazynpm.sh" "LazyNpm"
  confirm_step "${inc_path}/dev/lmstudio.sh" "LM Studio"
  confirm_step "${inc_path}/dev/lynx.sh" "Lynx"
  confirm_step "${inc_path}/dev/maven.sh" "Maven"
  confirm_step "${inc_path}/dev/neovim.sh" "Neovim"
  confirm_step "${inc_path}/dev/oh-my-posh.sh" "Oh-My-Posh"
  confirm_step "${inc_path}/dev/ollama.sh" "Ollama"
  confirm_step "${inc_path}/dev/open-webui.sh" "Open WebUI"
  confirm_step "${inc_path}/dev/openclaw.sh" "OpenClaw"
  confirm_step "${inc_path}/dev/opencode.sh" "OpenCode"
  confirm_step "${inc_path}/dev/pi.sh" "Pi Coding Agent"
  confirm_step "${inc_path}/dev/postman.sh" "Postman"
  confirm_step "${inc_path}/dev/pre-commit.sh" "pre-commit"
  confirm_step "${inc_path}/dev/qwen-code.sh" "Qwen Code"
  confirm_step "${inc_path}/dev/shellcheck.sh" "ShellCheck"
  confirm_step "${inc_path}/dev/skills-ref.sh" "skills-ref"
  confirm_step "${inc_path}/dev/sourcegit.sh" "SourceGit"
  confirm_step "${inc_path}/dev/tmux.sh" "tmux"
  confirm_step "${inc_path}/dev/vscode.sh" "Visual Studio Code"
  confirm_step "${inc_path}/dev/vscode-insiders.sh" "Visual Studio Code Insiders"
  confirm_step "${inc_path}/dev/vscodium.sh" "VS Codium"
  confirm_step "${inc_path}/dev/warp.sh" "Warp"
  confirm_step "${inc_path}/dev/zed.sh" "Zed"

  # Ops tools.
  confirm_step "${inc_path}/ops/aws.sh" "AWS CLI"
  confirm_step "${inc_path}/ops/litellm.sh" "LiteLLM"
  confirm_step "${inc_path}/ops/terraform.sh" "Terraform"

  # Hardware utilities.
  confirm_step "${inc_path}/phy/amdgpu-top.sh" "amdgpu_top"
  confirm_step "${inc_path}/phy/rocm.sh" "ROCm utilities"

  # Tidy up.
  step "${inc_path}/sys/bashrc.sh"
  step "${inc_path}/sys/teardown.sh"

}
