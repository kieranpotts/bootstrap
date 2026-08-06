#!/usr/bin/env bash

#
# Shared install step sequence.
#
# Sourced by both `run/bootstrap` (full provisioning from scratch) and
# `run/update` (update an already-bootstrapped machine). Defines
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

# run_install_steps - Run the shared install/update step sequence.
#
# Requires the caller to have already sourced the helper functions in
# `run/inc/fn/*.sh` (notably `step` and `print_step`) and set `inc_path`.
# Each step runs via `step()` in an isolated subshell, so a single failure
# is logged and does not abort the run.
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

  # Web browsers.
  step "${inc_path}/web/chrome.sh"
  step "${inc_path}/web/edge.sh"
  step "${inc_path}/web/firefox.sh"

  # Applications.
  step "${inc_path}/app/deja-dup.sh"
  step "${inc_path}/app/drawio.sh"
  step "${inc_path}/app/dropbox.sh"
  step "${inc_path}/app/keepassxc.sh"
  step "${inc_path}/app/mozilla-vpn.sh"
  step "${inc_path}/app/obsidian.sh"
  step "${inc_path}/app/orca.sh"
  step "${inc_path}/app/pass.sh"
  step "${inc_path}/app/pied.sh"
  step "${inc_path}/app/proton-mail.sh"
  step "${inc_path}/app/proton-vpn.sh"
  step "${inc_path}/app/voxd.sh"
  step "${inc_path}/app/xpdf-reader.sh"

  # Dev tools.
  step "${inc_path}/dev/aider.sh"
  step "${inc_path}/dev/bruno.sh"
  step "${inc_path}/dev/claude.sh"
  step "${inc_path}/dev/cline.sh"
  step "${inc_path}/dev/codespell.sh"
  step "${inc_path}/dev/continue.sh"
  step "${inc_path}/dev/copilot.sh"
  step "${inc_path}/dev/ctop.sh"
  step "${inc_path}/dev/cursor-cli.sh"
  step "${inc_path}/dev/cursor-gui.sh"
  step "${inc_path}/dev/delta.sh"
  step "${inc_path}/dev/docker-credential-pass.sh"
  step "${inc_path}/dev/docker-mcp.sh"
  step "${inc_path}/dev/frame0.sh"
  step "${inc_path}/dev/gh.sh"
  step "${inc_path}/dev/ghostty.sh"
  step "${inc_path}/dev/git-lfs.sh"
  step "${inc_path}/dev/hermes-agent.sh"
  step "${inc_path}/dev/insomnia.sh"
  step "${inc_path}/dev/jetbrains-toolbox.sh"
  step "${inc_path}/dev/lazydocker.sh"
  step "${inc_path}/dev/lazygit.sh"
  step "${inc_path}/dev/lmstudio.sh"
  step "${inc_path}/dev/maven.sh"
  step "${inc_path}/dev/neovim.sh"
  step "${inc_path}/dev/oh-my-posh.sh"
  step "${inc_path}/dev/ollama.sh"
  step "${inc_path}/dev/open-webui.sh"
  step "${inc_path}/dev/openclaw.sh"
  step "${inc_path}/dev/opencode.sh"
  step "${inc_path}/dev/pi.sh"
  step "${inc_path}/dev/postman.sh"
  step "${inc_path}/dev/pre-commit.sh"
  step "${inc_path}/dev/qwen-code.sh"
  step "${inc_path}/dev/shellcheck.sh"
  step "${inc_path}/dev/skills-ref.sh"
  step "${inc_path}/dev/sourcegit.sh"
  step "${inc_path}/dev/tmux.sh"
  step "${inc_path}/dev/vscode.sh"
  step "${inc_path}/dev/vscode-insiders.sh"
  step "${inc_path}/dev/vscodium.sh"
  step "${inc_path}/dev/warp.sh"
  step "${inc_path}/dev/zed.sh"

  # Ops tools.
  step "${inc_path}/ops/aws.sh"
  step "${inc_path}/ops/litellm.sh"
  step "${inc_path}/ops/terraform.sh"

  # Hardware utilities.
  step "${inc_path}/phy/amdgpu-top.sh"
  step "${inc_path}/phy/rocm.sh"

  # Tidy up.
  step "${inc_path}/sys/bashrc.sh"
  step "${inc_path}/sys/teardown.sh"

}
