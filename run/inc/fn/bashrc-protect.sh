#!/usr/bin/env bash

#
# Protect ~/.bashrc from being modified by third-party installers.
#
# When ~/local.bashrc exists, it is the designated writable Bash startup file
# for this bootstrap. The bootstrap's own scripts respect that and write to
# ~/local.bashrc rather than ~/.bashrc.
#
# But some third-party installers piped from upstream (Continue CLI, Poetry,
# etc.) ignore that convention and write directly to ~/.bashrc, and a few even
# replace it as a file (eg. via `mv`), clobbering the symlink-to-managed-dotfile
# convention.
#
# This module solves the problem by snapshotting ~/.bashrc at the start of the
# bootstrap and, at the end, restores the original (including its symlink
# target, if any). It redirects any new lines introduced during the bootstrap
# routine into ~/local.bashrc.
#
# Globals (set by `bashrc_snapshot`, read by `bashrc_restore`):
#   bashrc_protected    - 1 if protection is active, 0 otherwise.
#   bashrc_snapshot_dir - Temp dir holding the snapshot.
#

# bashrc_snapshot - Record the starting state of ~/.bashrc.
#
# Activates only when ~/local.bashrc exists (i.e. when the user has opted into
# the "~/.bashrc is sacred; write to ~/local.bashrc instead" convention).
#
bashrc_snapshot() {
  # `bashrc_protected` and `bashrc_snapshot_dir` are intentionally global —
  # they are read by `bashrc_restore` later in the bootstrap.
  bashrc_protected=0

  if [[ ! -f "${HOME}/local.bashrc" ]]; then
    return 0
  fi

  if [[ ! -e "${HOME}/.bashrc" ]]; then
    return 0
  fi

  bashrc_protected=1
  bashrc_snapshot_dir=$(mktemp -d)

  # Record the symlink target if ~/.bashrc is a symlink, so we can re-create it.
  if [[ -L "${HOME}/.bashrc" ]]; then
    readlink "${HOME}/.bashrc" > "${bashrc_snapshot_dir}/symlink_target"
  fi

  # Snapshot the resolved content (follows symlinks).
  cp -L "${HOME}/.bashrc" "${bashrc_snapshot_dir}/content"

  print_info "Snapshotted ~/.bashrc; any third-party modifications will be redirected to ~/local.bashrc."
}

# bashrc_restore - Compare the current state of ~/.bashrc to the snapshot.
#
# If modified, append any new lines to ~/local.bashrc, then restore the
# original ~/.bashrc (including its symlink, if it was one).
#
bashrc_restore() {
  if [[ "${bashrc_protected:-0}" -ne 1 ]]; then
    return 0
  fi

  # If unchanged, nothing to do.
  if cmp -s "${HOME}/.bashrc" "${bashrc_snapshot_dir}/content"; then
    rm -rf "${bashrc_snapshot_dir}"
    return 0
  fi

  # shellcheck disable=SC2088
  print_warning "~/.bashrc was modified during the bootstrap (likely by a third-party installer)."

  # Extract lines added in the current ~/.bashrc relative to the snapshot.
  # `diff` exits non-zero when files differ; suppress under `set -e`.
  local added_lines
  added_lines=$(diff "${bashrc_snapshot_dir}/content" "${HOME}/.bashrc" 2>/dev/null | grep '^>' | sed 's/^> //' || true)

  if [[ -n "${added_lines}" ]]; then
    print_info "Redirecting added lines to ~/local.bashrc."
    {
      printf '\n# Added by bootstrap on %s (redirected from ~/.bashrc).\n' "$(date +%F)"
      printf '%s\n' "${added_lines}"
    } >> "${HOME}/local.bashrc"
  fi

  # Restore the original ~/.bashrc.
  if [[ -f "${bashrc_snapshot_dir}/symlink_target" ]]; then
    local target
    target=$(cat "${bashrc_snapshot_dir}/symlink_target")
    rm -f "${HOME}/.bashrc"
    ln -s "${target}" "${HOME}/.bashrc"
    print_success "Restored ~/.bashrc symlink → ${target}."
  else
    cp "${bashrc_snapshot_dir}/content" "${HOME}/.bashrc"
    print_success "Restored ~/.bashrc to its pre-bootstrap state."
  fi

  rm -rf "${bashrc_snapshot_dir}"
}
