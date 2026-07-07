#!/usr/bin/env bash

#
# Install AWS CLI.
#
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
#

print_step "Installing AWS CLI."

# Remember the current working diectory, so we can change back here later.
cwd=$(pwd)

# Create a temporary directory.
tmp_dir=$(mktemp -d)

# Move to the temporary directory.
cd "$tmp_dir" || true

# Download and unzip the bundle (~50MB). AWS doesn't publish the version
# in the canonical download URL, so we re-fetch unconditionally; the bundled
# installer's `--update` flag handles the "already-current" case efficiently.
print_info "Downloading official AWS CLI installer."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -u awscliv2.zip

# Run the installation. Update the CLI if it's already installed.
print_info "Running the AWS CLI installer."
superdo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

# Check the installed version.
aws --version

# Move back to the original directory.
cd "${cwd}" || true

# Remove the temporary directory.
rm -rf "$tmp_dir"

# Check the installed version.
aws --version

print_success "AWS CLI installed successfully."
