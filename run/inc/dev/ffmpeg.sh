#!/usr/bin/env bash

#
# Install FFmpeg - audio/video conversion, inspection, and playback (`ffmpeg`,
# `ffprobe`, `ffplay`).
#
# https://ffmpeg.org/
#

# No-op on `./run/update`. Package is kept current by `apt upgrade`.
is_updating && return 0

print_step "Installing FFmpeg."

print_info "Installing/updating FFmpeg via APT."
superdo apt-get install -y ffmpeg

ffmpeg -version
