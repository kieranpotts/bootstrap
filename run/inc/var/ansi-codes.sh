#!/usr/bin/env bash

#
# List of useful ANSI color codes.
#
# https://stackoverflow.com/a/28938235
# https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
# https://github.com/fidian/ansi
#

# Reset all colors and decorations.
export RESET='\033[0m'

# Text decorations.
export BOLD='\033[1m'
export DIM='\033[2m'
export ITALIC='\033[3m'
export UNDERLINE='\033[4m'
export BLINKING='\033[5m'
export REVERSED='\033[7m'
export INVISIBLE='\033[8m'
export STRIKETHROUGH='\033[9m'

# Regular colour palette.
export BLACK='\033[30m'
export RED='\033[31m'
export GREEN='\033[32m'
export YELLOW='\033[33m'
export BLUE='\033[34m'
export PURPLE='\033[35m'
export CYAN='\033[36m'
export WHITE='\033[37m'

# Background colors.
export ON_BLACK='\033[40m'
export ON_RED='\033[41m'
export ON_GREEN='\033[42m'
export ON_YELLOW='\033[43m'
export ON_BLUE='\033[44m'
export ON_PURPLE='\033[45m'
export ON_CYAN='\033[46m'
export ON_WHITE='\033[47m'

# Bright colors - equivalent of for `${COLOR}${BOLD}`.
export BRIGHT_BLACK='\033[90m'
export BRIGHT_RED='\033[91m'
export BRIGHT_GREEN='\033[92m'
export BRIGHT_YELLOW='\033[93m'
export BRIGHT_BLUE='\033[94m'
export BRIGHT_PURPLE='\033[95m'
export BRIGHT_CYAN='\033[96m'
export BRIGHT_WHITE='\033[97m'

export ON_BRIGHT_BLACK='\033[100m'
export ON_BRIGHT_RED='\033[101m'
export ON_BRIGHT_GREEN='\033[102m'
export ON_BRIGHT_YELLOW='\033[103m'
export ON_BRIGHT_BLUE='\033[104m'
export ON_BRIGHT_PURPLE='\033[105m'
export ON_BRIGHT_CYAN='\033[106m'
export ON_BRIGHT_WHITE='\033[107m'
