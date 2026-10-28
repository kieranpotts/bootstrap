#!/usr/bin/env bash

#
# Uninstall Aider.
#
# Aider was previously installed via `aider-install`, which is itself installed
# in pipx. `aider-install` then installs the `aider-chat` package as a uv tool.
# So both must be removed, in reverse order. `uv` itself is left in place, as
# other tools may be managed by it.
#
# https://aider.chat/docs/install.html
#

print_step "Uninstalling Aider."

# uv and pipx place executables in ~/.local/bin, which is not on PATH in a
# non-interactive shell.
export PATH="${HOME}/.local/bin:${PATH}"

if command -v uv >/dev/null 2>&1 && uv tool list 2>/dev/null | grep -q '^aider-chat '; then
  print_info "Uninstalling aider-chat via uv."
  uv tool uninstall aider-chat
else
  print_info "aider-chat is not installed as a uv tool. Skipping."
fi

if python3 -m pipx list --short 2>/dev/null | grep -q '^aider-install '; then
  print_info "Uninstalling aider installer from pipx."
  python3 -m pipx uninstall aider-install
else
  print_info "aider-install is not installed in pipx. Skipping."
fi
