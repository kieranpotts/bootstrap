#!/usr/bin/env bash

#
# Install the XPDF Reader application.
#
# Treating this as a CLI application, as we mostly want it for its utilities
# like `pdftotext. Though the `xpdf` reader itself is a GUI application.
#
# https://www.xpdfreader.com
# https://www.xpdfreader.com/support.html
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing XPDF Reader."

if command -v xpdf >/dev/null 2>&1; then
    print_info "XPDF Reader is already installed. Skipping."
else
    superdo apt-get install -y xpdf
    print_success "XPDF Reader installed successfully."
fi
