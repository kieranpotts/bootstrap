#!/usr/bin/env bash

#
# Installs Qwen Code.
#
# Usage:
#   qwen --auth-type openai --model qwen3.6
#
# This skips the cloud auth screen and loads a local Ollama model - which
# must be configured in ~/.qwen/settings.json.
#
# https://qwen.ai/qwencode
#

print_step "Installing Qwen Code."

# The installer has no flag to suppress its post-install auto-launch (`exec qwen`),
# so we strip that line from the script before running it. Hacky 🙁

print_info "Installing/updating Qwen Code using official install shell script."
curl -fsSL https://qwen-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/install-qwen.sh \
  | sed '/exec qwen/d' \
  | bash
