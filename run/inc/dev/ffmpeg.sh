#!/usr/bin/env bash

#
# Install FFmpeg - audio/video conversion, inspection, and playback (`ffmpeg`,
# `ffprobe`, `ffplay`).
#
# https://ffmpeg.org/
#

print_step "Installing FFmpeg."

print_info "Installing/updating FFmpeg via APT."
# --no-install-recommends: the recommends chain otherwise pulls in
# libfluidsynth and a ~5MB MIDI soundfont (timgm6mb-soundfont), neither of
# which are needed for the audio/video conversion this step is installed for.
superdo apt-get install -y --no-install-recommends ffmpeg

ffmpeg -version
