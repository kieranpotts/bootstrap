#!/bin/bash

# ==============================================================================
# Installs Maven.
#
# https://maven.apache.org/
# ==============================================================================

startNewTask "Install Maven"

superdo apt install maven -y
