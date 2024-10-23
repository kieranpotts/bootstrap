#!/bin/bash

# ==============================================================================
# Install AWS C:I.
#
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
# ==============================================================================

startNewTask "Install AWS CLI"

# Remember the current working diectory, so we can change back here later.
cwd=$(pwd)

# Create a temporary directory.
tmp_dir=$(mktemp -d)

# Move to the temporary directory.
cd "$tmp_dir"

# Download and unzip the package.
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -u awscliv2.zip

# Run the installation. Update the CLI if it's already installed.
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

# Move back to the original directory.
cd ${cwd}

# Remove the temporary directory.
rm -rf "$tmp_dir"

# Check the installed version.
aws --version
