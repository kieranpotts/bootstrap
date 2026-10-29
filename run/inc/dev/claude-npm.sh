#!/usr/bin/env bash

#
# Uninstall the npm package of Claude Code.
#
# Claude Code was previously installed as a global npm package,
# `@anthropic-ai/claude-code`, under NVM. It is now installed as a native
# binary by `dev/claude.sh`, so the npm package is removed. NVM keeps separate
# globals per Node.js version, and the default version has been bumped over
# time, so the package is removed from every NVM-managed version that has it.
# Node.js and NVM themselves are left in place.
#
# https://code.claude.com/docs/en/setup#uninstall-with-npm
#

print_step "Uninstalling Claude Code npm package."

nvm_dir="${NVM_DIR:-${HOME}/.nvm}"

if [[ -s "${nvm_dir}/nvm.sh" ]]; then
  source "${nvm_dir}/nvm.sh"
else
  print_info "NVM is not installed. Skipping."
  return 0
fi

found=false

for package_dir in "${nvm_dir}"/versions/node/*/lib/node_modules/@anthropic-ai/claude-code; do
  [[ -d "${package_dir}" ]] || continue
  found=true

  # Extract the version from `<nvm_dir>/versions/node/<version>/lib/...`.
  node_version="${package_dir#"${nvm_dir}/versions/node/"}"
  node_version="${node_version%%/*}"

  print_info "Uninstalling @anthropic-ai/claude-code from Node.js ${node_version}."
  nvm exec --silent "${node_version}" npm uninstall -g @anthropic-ai/claude-code
done

if [[ "${found}" == false ]]; then
  print_info "@anthropic-ai/claude-code is not installed in any NVM-managed Node.js version. Skipping."
fi
